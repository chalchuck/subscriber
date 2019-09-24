jQuery(function() {
  $('.select-interval').select2({
    theme: 'classic',
    allowClear: true,
    placeholder: 'Select billing interval',
    minimumResultsForSearch: Infinity
  });

  $('textarea').autogrow();

  $('.select-plan').select2({
    theme: 'classic',
    allowClear: true,
    placeholder: 'Select plan'
  });

  $('.select-duration').select2({
    theme: 'classic',
    allowClear: true,
    placeholder: 'Choose duration of coupon',
    minimumResultsForSearch: Infinity
  });

  $('.select-customer').select2({
    theme: 'classic',
    allowClear: true,
    placeholder: 'Select customer'
  });

  $("#InvoiceRelief").on("show.bs.modal", function(event) {
    var button, modal, r, recipients;
    button = $(event.relatedTarget);
    recipients = button.data("whatever");
    console.dir(r = JSON.stringify(recipients));
    modal = $(this);
    modal.find(".table .total-amount").text(recipients.amount_due);
    modal.find(".table .discount").text(recipients.discount);
    return modal.find(".table .amount-due").text(recipients.relief);
  });

  $('.singledate').daterangepicker({
    'singleDatePicker': true,
    'showDropdowns': true,
    'autoApply': true,
    'opens': 'center',
    'locale': {
      'format': 'YYYY/MM/DD'
    },
    "drops": "up",
    'alwaysShowCalendars': true,
    'startDate': moment()
  });
});
