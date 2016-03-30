$(document).on('turbolinks:load', function() {

  $('table.row-links').on('click', 'tbody tr', function(event) {
    Turbolinks.visit($(this).data('link'))
  });

  $('input.pickdate').datepicker({
    autoclose: true,
    todayHighlight: true
  });

  $('.field_with_errors').parent().addClass('has-error')
  $('.field_with_errors label').addClass('control-label')
});
