$(document).on('turbolinks:load', function() {

  // Link to specified page when clicking table rows
  $('table.row-links').on('click', 'tbody tr', function(event) {
    Turbolinks.visit($(this).data('link'))
  });

  // Init date pickers
  $('input.pickdate').datepicker({
    autoclose: true,
    todayHighlight: true
  });

  $('input.pickdate-top').datepicker({
    autoclose: true,
    todayHighlight: true,
    orientation: "bottom auto"
  });
});
