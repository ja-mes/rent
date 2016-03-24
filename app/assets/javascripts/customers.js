$(document).on('turbolinks:load', function() {

  $('#customers_index_table').on('click', 'tbody tr', function(event) {
    Turbolinks.visit($(this).data('link'))
  });

});
