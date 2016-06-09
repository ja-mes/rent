$(document).on('turbolinks:load', function() {
  function num_from_elem(elem) {
    return +$(elem).html().replace(/[^0-9\.]+/g,"")
  }

  function format_currency(elem, amount) {
    $(elem).html('$' + amount.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,"));
  }

  function calculate_cleared_balance() {
    var total = num_from_elem('#reconcile_cleared_balance')

    $('.reconcile_deposit_amount').each(function(i, val) {
      var checkbox = $(val).parent().closest('tr').find('.reconcile_deposit_check_box');

      if (checkbox.prop('checked')) {
        total += num_from_elem(val)
      }
    });

    format_currency('#reconcile_cleared_balance', total)

    //debugger;
  }

  $('.reconcile_deposit_check_box').click(calculate_cleared_balance)

  calculate_cleared_balance()
});
