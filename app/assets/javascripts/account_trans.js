function add_fields(link, association, content) {  
  event.preventDefault();
  var new_id = new Date().getTime();  
  var regexp = new RegExp("new_" + association, "g");  
  $('table tr:last').after(content.replace(regexp, new_id));  
}

$(document).on("click", '.remove_account_tran', function() {
  event.preventDefault();
  $(this).prev().val("1");
  $(this).closest('.account_tran_fields').hide();
});

$(document).on('turbolinks:load', function() {
  $('.remove_account_tran').prev().val("false");
});
