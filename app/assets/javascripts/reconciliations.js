$(document).on('turbolinks:load', function() {
  function num_from_elem(elem) {
    if ($(elem)[0].nodeName.toLowerCase() === 'input') {
      var val = $(elem).val()
    }
    else {
      var val = $(elem).html()
    }
    return +val.replace(/[^0-9\.]+/g,"")
  }

  function format_currency(elem, amount) {
    $(elem).html('$' + amount.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,"));
  }

  function calculate_cleared_balance() {
    var total = num_from_elem('#reconcile_saved_cleared_balance');
    var ending_balance = num_from_elem('#reconcile_ending_balance');

    $('.reconcile_deposit_amount').each(function(i, val) {
      var checkbox = $(val).parent().closest('tr').find('.reconcile_deposit_check_box');

      if (checkbox.prop('checked')) {
        total += num_from_elem(val)
      }
    });

    format_currency('#reconcile_cleared_balance', total);
    format_currency('#reconcile_difference', total - ending_balance)
  }

  $('.reconcile_deposit_check_box').click(calculate_cleared_balance);
  $('#reconcile_ending_balance').change(calculate_cleared_balance);

  calculate_cleared_balance();
});
