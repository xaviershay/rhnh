function spamBehaviour(enableAlternateFunc) {
  return function () {
    $(this).find('input').attr('src', '/images/silk/flag_grey.png').attr('disabled', true);
    enableAlternateFunc($(this).parent('td'));
    $.ajax({
      type: "POST",
      url: $(this).attr('action'),
      beforeSend: function(xhr) {
        xhr.setRequestHeader("Accept", "application/json");
      },
      dataType: 'json',
      data: {},
      success: function(msg){
        display = msg.undo_message
        if (msg.undo_path)
          display += '<span class="undo-link"> (<a class="undo-link" href="' + msg.undo_path + '">undo</a>)</span>';
        humanMsg.displayMsg(display);
      },
      error: function (XMLHttpRequest, textStatus, errorThrown) {
        humanMsg.displayMsg( 'Could not alter comment' );
      }
    });
    return false;
  }
}  
$(document).ready(function() {
  destroyAndUndoBehaviour('comments')();

  $('form.ham').submit( spamBehaviour(function(e) { e.find('form.spam input').attr('src', '/images/silk/flag_orange.png').attr('disabled', false) }));
  $('form.spam').submit(spamBehaviour(function(e) { e.find('form.ham  input').attr('src', '/images/silk/flag_green.png' ).attr('disabled', false) }));
}); // Defined in admin/common.js
