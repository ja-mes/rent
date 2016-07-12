function update_delete_button() {
  if ($('.account_tran_fields:visible').length <= 1) {
    $('.remove_account_tran').closest('.form-group').hide();
  }
  else {
    $('.remove_account_tran').closest('.form-group').show();
  }
}

function add_fields(link, association, content) {
  event.preventDefault();
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $('.account_tran_fields:last').after(content.replace(regexp, new_id));
  $(this).closest('.remove_account_tran').show();

  $('.select2').select2();
  update_delete_button()
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
    update_delete_button();
    $('.remove_account_tran').prev().val("false");
  });

  $(document).on('change', '.account_tran_amount', function() {
    calculateTotal()
  });

  $(document).on("click", '.remove_account_tran', function() {
    event.preventDefault();
    $(this).prev().val("1");
    $(this).closest('.account_tran_fields').hide();
    calculateTotal();

    update_delete_button();
  });
})();
