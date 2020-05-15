App.assessment = App.cable.subscriptions.create "AssessmentChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) -> (
    # Called when there's incoming data on the websocket for this channel
    console.log(data["jobs_queue"]);
    $('#jobs_queue').html(data["jobs_queue"]);
  )

  speak: ->
    @perform 'speak'
