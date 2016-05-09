;(function () {

  function calculateTotal() {
    var total = 0;

    $('.invoice_account_tran_amount').each(function(i, elem) {
      total += Number($(elem).val().replace(/[^0-9\.]+/g,""));
    });

    return "$" + total.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
  }

  $(document).on('change', '.invoice_account_tran_amount', function() {
    $('#invoice_trans_total').html(calculateTotal());
  });

  $(document).on('turbolinks:load', function() {
    $('#invoice_trans_total').html(calculateTotal());
  });

})();
