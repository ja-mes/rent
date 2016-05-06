// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function() {

  function calculateTotal() {
    var total = 0;

    $('.deposit_amount').each(function(i, val) {
      var checkbox = $(val).parent().closest('tr').find('.deposit_check_box');

      if (checkbox.prop('checked')) {
        total += Number($(val).html().replace(/[^0-9\.]+/g,""));
      }
    });

    $('#deposit_form h4').html("$" + total.toFixed(2).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,"));
  }
   
  $('#deposit_form.edit_deposit input[type="checkbox"]').prop({ 'checked': true });
  calculateTotal();


  $('.deposit_check_box').click(function() {
    calculateTotal();

    if ($('.deposit_check_box:checked').length === $('.deposit_check_box').length) {
      $('.deposit_check_box_select_all').prop({ 'checked': true })
    }
    else {
      $('.deposit_check_box_select_all').prop({ 'checked': false })
    }
  });

  $('.deposit_check_box_select_all').click(function() {
    var bool;
    if ($(this).prop('checked') === true) {
      bool = true
    }
    else {
      bool = false
    }

    $('#deposit_form input[type="checkbox"]').prop({ 'checked': bool });

    calculateTotal();
  });
});


