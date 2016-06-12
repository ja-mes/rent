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

    $('.reconcile_amount').each(function(i, val) {
      var checkbox = $(val).parent().closest('tr').find('.reconcile_check_box');

      if (checkbox.prop('checked')) {
        if ($(this).hasClass('reconcile_check_amount')) {
          total -= num_from_elem(val);
        }
        else if($(this).hasClass('reconcile_deposit_amount')) {
          total += num_from_elem(val);
        }
          
      }
    });

    format_currency('#reconcile_cleared_balance', total);

    var difference = ending_balance - total;

    if (difference != 0) {
      $('#reconcile_adj_messg').show();
      format_currency('#reconcile_adj_messg #adj_amount', difference)
    }
    else {
      $('#reconcile_adj_messg').hide()
    }

    format_currency('#reconcile_difference', ending_balance - total)
  }

  $('.reconcile_select_all').click(function() {
    var bool = false;
    if ($(this).prop('checked') === true) {
      bool = true
    }

    if ($(this).hasClass('reconcile_select_all_checks')) {
      $('#reconciliation_checks input[type="checkbox"]').prop({ 'checked': bool });
    }
    else if($(this).hasClass('reconcile_select_all_deposits')) {
      $('#reconciliation_deposits input[type="checkbox"]').prop({ 'checked': bool });
    }

    calculate_cleared_balance()
  });

  $('.reconcile_check_box').click(calculate_cleared_balance);
  $('#reconcile_ending_balance').change(calculate_cleared_balance);

  calculate_cleared_balance();
});
