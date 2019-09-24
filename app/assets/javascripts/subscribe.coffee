# $(document).on "turbolinks:load", ->
#   $('.select-interval').select2
#     theme: 'classic'
#     allowClear: true
#     placeholder: 'Select billing interval'
#     minimumResultsForSearch: Infinity

#   $('textarea').autogrow()

#   $('.select-plan').select2
#     theme: 'classic'
#     allowClear: true
#     placeholder: 'Select plan'

#   $('.select-duration').select2
#     theme: 'classic'
#     allowClear: true
#     placeholder: 'Choose duration of coupon'
#     minimumResultsForSearch: Infinity

#   # Setup plugin and define optional event callbacks
#   $('.infinite-table').infinitePages
#     debug: true
#     buffer: 200 # load new page when within 200px of nav link
#     context: '.pane' # define the scrolling container (defaults to window)
#     loading: ->
#      $(this).text("Loading...")
#     success: ->
#     error: ->
#      $(this).text("Trouble! Please drink some coconut water and click again")

#   $('.select-customer').select2
#     theme: 'classic'
#     allowClear: true
#     placeholder: 'Select customer'
#     # minimumResultsForSearch: Infinity

#   $("#InvoiceRelief").on "show.bs.modal", (event) ->
#     button = $(event.relatedTarget)
#     recipients = button.data("whatever")
#     console.dir(r=JSON.stringify(recipients))
#     modal = $(this)
#     modal.find(".table .total-amount").text recipients.amount_due
#     modal.find(".table .discount").text recipients.discount
#     modal.find(".table .amount-due").text recipients.relief

#   $('.singledate').daterangepicker {
#     'singleDatePicker': true
#     'showDropdowns': true
#     'autoApply': true
#     'opens': 'center'
#     'locale':'format': 'YYYY/MM/DD'
#     "drops": "up"
#     'alwaysShowCalendars': true
#     'startDate': moment(),
#   }, (start, end, label) ->
#     console.log 'New date range selected: \' + start.format(\'YYYY-MM-DD\') + \' to \' + end.format(\'YYYY-MM-DD\') + \' (predefined range: \' + label + \')'
#     return
