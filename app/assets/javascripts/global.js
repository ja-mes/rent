$(document).on('turbolinks:load', function() {

  // Link to specified page when clicking table rows
  $('table.row-links').on('click', 'tbody tr', function(event) {
    Turbolinks.visit($(this).data('link'))
  });

  $('#customers_search input').focus()
});
