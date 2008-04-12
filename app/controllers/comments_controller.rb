class CommentsController < ApplicationController
  include UrlHelper

  before_filter :find_post, :except => [:new]

  def index
    if request.post? || openid_completion?(request)
      create
    else
      #TODO: Comments#index
      @comments = @post.approved_comments
    end
  end

  def new
    @comment = Comment.build_for_preview(params[:comment])

    respond_to do |format|
      format.js do
        render :partial => 'comment.html.erb'
      end
    end
  end

  def create
    @comment = Comment.new((session[:pending_comment] || params[:comment] || {}).reject {|key, value| !Comment.protected_attribute?(key) })
    @comment.post = @post
    @comment.env = request.env

    session[:pending_comment] = nil

    if @comment.requires_openid_authentication?
      begin
        sreg_extension = OpenID::SReg::Request.new(['fullname'], ['email'])

        return if open_id_authenticate(
          @comment.author, 
          :before_redirect => lambda { session[:pending_comment] = params[:comment] },
          :extensions      => [sreg_extension]
        ) do |response|
          open_id_fields = response.extension_response(sreg_extension.ns_uri, false)

          @comment.post = @post

          @comment.author_url              = @comment.author
          @comment.author                  = open_id_fields["fullname"].to_s
          @comment.author_email            = open_id_fields["email"].to_s
          @comment.author_openid_authority = response.endpoint.server_url

          @comment.openid_error = ""
        end
      rescue OpenID::DiscoveryFailure
        @comment.openid_error = "Unable to find OpenID server for <q>#{@comment.author}</q>"
      rescue HyperOpenID::AuthenticationFailure
        @comment.openid_error = "Could not authenticate <q>#{@comment.author}</q>"
      end
    end

    if @comment.save
      redirect_to post_path(@post)
    else
      render :template => 'posts/show'
    end
  end

  protected

  def find_post
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
  end
end
