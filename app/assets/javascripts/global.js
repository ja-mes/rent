$(document).on('turbolinks:load', function() {

  // Link to specified page when clicking table rows
  $('table.row-links').on('click', 'tbody tr', function(event) {
    Turbolinks.visit($(this).data('link'))
  });

  // focus customer search box when the page loads
  $('#customers_search input').focus()

  // automatically submit when customers ative or all select changes
  $('#customer_display').change(function() {
    $(this).submit()
  });
});
