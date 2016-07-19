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
    var days_this_month = new Date(date.getFullYear(), date.getMonth()+1, 0).getDate();
    var days_next_month = new Date(date.getFullYear(), date.getMonth() + 2, 0).getDate();

    function calculateDueDate() {
      var dd = $('#customer_due_date').val();
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


      var today = date.getDate();
      var rent_day = +$('#customer_due_date').val();

      if (rent_day === today) {
        var total_days = days_this_month - 1;
      }
      else if (rent_day == 1) {
        total_days = days_this_month - today
      }
      else if (rent_day < today) {
        var total_days = (rent_day - 1) + (days_this_month - today);
      }
      else {
        var total_days = rent_day - today
      }

      $('#customer_days_in_month').html(total_days);
    }

    $('#customer_due_date').on('change', calculateDueDate);
    calculateDueDate();


    $('#customer_prorated_rent_checkbox').prop({ 'checked': true });
    $('#customer_deposit_checkbox').prop({ 'checked': true });

    $('#customer_rent, #customer_due_date').on('change', function() {
      var rent_day = +$('#customer_due_date').val();
      var rent_amount = +$('#customer_rent').val();
      var prorated_rent = 0

      var date = new Date();
      var days_this_month = new Date(date.getFullYear(), date.getMonth()+1, 0).getDate();

      if (date.getDate() === rent_day) {
        prorated_rent = rent_amount
      }
      else if (rent_day === 1) {
        prorated_rent = +((rent_amount / days_this_month) * (days_this_month - date.getDate())).toFixed(2)
      }
      else {
        if (rent_day < date.getDate()) {
          amount_for_this_month = +((rent_amount / days_this_month) * (days_this_month - date.getDate()))
          amount_for_next_month = +((rent_amount / days_next_month) * (rent_day - 1))

          prorated_rent = +(amount_for_this_month + amount_for_next_month).toFixed(2)
        }
        else {
          prorated_rent = +((rent_amount / days_this_month) * (rent_day - todays_day)).toFixed(2)
        }
      }

      format_currency('#customer_prorated_rent_amount', prorated_rent)
    });

    $('#customer_deposit').on('change', function() {
      format_currency('#customer_deposit_amount', +$(this).val())
    });
  }
});
