$(document).ready () ->
  $('.show-question-detail-button').click (event) ->
    $('.question-detail').removeClass 'hidden'
    $('.show-question-detail-button').addClass 'hidden'

  $('.show-answer-button').click (event) ->
    $("form")[0].answer_revealed_at.value = Math.round(new Date().getTime() / 1000)

    $('.show-answer-button').addClass 'hidden'
    $('.not-interested-button').addClass 'hidden'
    $('.answer').removeClass 'hidden'
    $('.scoring').removeClass 'hidden'
    $('.questioning').addClass 'hidden'
    $("html, body").animate({ scrollTop: 0 }, "fast")

