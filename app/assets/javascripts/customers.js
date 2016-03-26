$(document).on('turbolinks:load', function() {

  $('table.row-links').on('click', 'tbody tr', function(event) {
    Turbolinks.visit($(this).data('link'))
  });

});
