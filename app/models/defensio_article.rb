module DefensioArticle
  def author
    config[:author, :name]
  end

  def author_email
    config[:author, :email]
  end

  def content
    body_html
  end

  def permalink
    slug
  end

  private

  def config
    @@config ||= Enki::Config.new("config/enki.yml")
  end
end
