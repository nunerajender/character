#
#  Video Extension (WIP)
#  ^^http://www.youtube.com/watch?v=aQPU0oyL3SY
#

window.Showdown.extensions.video = (converter) ->
  [
    {
      type    : 'lang',
      regex   : '\\^\\^([\\S]+)',
      replace : (match, url) ->
        youtube = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/

        if youtube.test(url)
          m = url.match(youtube)
          if m and m[7].length == 11
            video_id = m[7]
            """<iframe  src="http://www.youtube.com/embed/#{video_id}?rel=0"
                        frameborder="0" allowfullscreen></iframe>"""
          else
            match
        else
          match
    }
  ]
