$(document).on('turbolinks:load', function() {

  if ($('body')[0].className == 'customers index') {
    $('#customer_display').change(function() {
      $(this).submit()
    });
  }

  if ($('body')[0].className == 'customers show') {
    $('#customer_show_display').change(function() {
      $(this).submit();
    });
  }

  if ($('body')[0].className === 'customers new') {
    function format_currency(elem, amount) {
      if ($(elem)[0]) {
        $(elem).html('$' + amount.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,"));
      }
    }

    var date = new Date();
    var yesterday = new Date(date.setDate(date.getDate() - 1));
    var days_in_month = new Date(date.getFullYear(), date.getMonth()+1, 0).getDate();

    function calculateDueDate() {
      var due_date = $('#customer_due_date').val();
      var dd = due_date;
      var mm = date.getMonth()+2; //January is 0!

      var yyyy = date.getFullYear();
      if(dd<10){
        dd='0'+dd
      }
      if(mm<10){
        mm='0'+mm
      }
      var next_due_date = mm+'/'+dd+'/'+yyyy;

      $('#customer_due_date_display').html(next_due_date)
    }

    $('#customer_due_date').on('change', calculateDueDate);
    calculateDueDate();


    $('#customer_prorated_rent_checkbox').prop({ 'checked': true });
    $('#customer_deposit_checkbox').prop({ 'checked': true });
    $('#customer_days_in_month').html(days_in_month - yesterday.getDate());

    $('#customer_rent').on('change', function() {
      var rent_amount = +$(this).val();

      var date = new Date();
      var yesterday = new Date(date.setDate(date.getDate() - 1));
      var days_in_month = new Date(date.getFullYear(), date.getMonth()+1, 0).getDate();

      if (yesterday.getDate() != 1) {
        rent_amount = +((rent_amount / days_in_month) * (days_in_month - yesterday.getDate())).toFixed(2)
      }

      format_currency('#customer_prorated_rent_amount', rent_amount)
    });

    $('#customer_deposit').on('change', function() {
      format_currency('#customer_deposit_amount', +$(this).val())
    });
  }
});
