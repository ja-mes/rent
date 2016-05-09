function add_fields(link, association, content) {  
  event.preventDefault();
  var new_id = new Date().getTime();  
  var regexp = new RegExp("new_" + association, "g");  
  $('table tr:last').after(content.replace(regexp, new_id));  
}

;(function () {

  function calculateTotal() {
    var total = 0;

    $('.account_tran_amount').each(function(i, elem) {
      if ($(elem).is(":visible")) {
        total += Number($(elem).val().replace(/[^0-9\.]+/g,""));
      }
    });

    $('#account_trans_total').html("$" + total.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,"));
  }

  $(document).on('turbolinks:load', function() {
    calculateTotal();
    $('.remove_account_tran').prev().val("false");
  });

  $(document).on('change', '.account_tran_amount', function() {
    calculateTotal()
  });

  $(document).on("click", '.remove_account_tran', function() {
    event.preventDefault();
    $(this).prev().val("1");
    $(this).closest('.account_tran_fields').hide();
    calculateTotal()
  });

})();
