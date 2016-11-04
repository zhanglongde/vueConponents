app =
  el: '#list'
  data:
    listX: ['a', 'b', 'c', 'd']
    listY: ['A', 'B', 'C', 'D']
  methods:
    sort: (list, id, tag, data)->
      console.log 'sort', list, id, tag, data
      tmp = list[data.index]
      list.splice data.index, 1
      list.splice id, 0, tmp
    move: (from, to, id, tag, data)->
      console.log 'move', from, to, id, tag, data
      tmp = from[data.index]
      from.splice data.index, 1
      to.splice id, 0, tmp
    remove: (from, tag, data)->
      console.log 'remove', from, tag, data
      from.splice data.index, 1

_ =
  on: (el, name, cb)->
    el.addEventListener name, cb
  off: (el, name, cb)->
    el.removeEventListener name, cb

dropTo = ''
app.directives =
  draggable:
    bind: ->
      @data = {}
      @dragstart = (e)=>
        e.target.classList.add @data.dragged
        e.dataTransfer.effectAllowed = 'all'
        e.dataTransfer.dropEffect = 'copy'
        e.dataTransfer.setData 'data', JSON.stringify(@data)
        e.dataTransfer.setData 'tag', @arg
        dropTo = @arg
        console.log 'start', @arg, @data
        false
      @dragend = (e)=>
        e.target.classList.remove @data.dragged
        console.log 'end', @arg
        dropTo = ''
        false
      @el.setAttribute 'draggable', true
      _.on @el, 'dragstart', @dragstart
      _.on @el, 'dragend', @dragend
    unbind: ->
      @el.setAttribute 'draggable', false
      _.off @el, 'dragstart', @dragstart
      _.off @el, 'dragend', @dragend
    update: (value, old)->
      @data = value

  dropzone:
    acceptStatement: true
    bind: ->
#console.log '+ dropzone', @arg
      @dragenter = (e)=>
        if dropTo == @arg
          e.target.classList.add @arg
        console.log 'enter', @arg
        false
      @dragleave = (e)=>
        if dropTo == @arg
          e.target.classList.remove @arg
        console.log 'leave', @arg
        false
      @drop = (e)=>
        e.preventDefault()  if e.preventDefault
        data = e.dataTransfer.getData 'data'
        tag = e.dataTransfer.getData 'tag'
        if dropTo == @arg
          @handler tag, JSON.parse(data)
          e.target.classList.remove @arg
        console.log 'drop', @arg
        false
      @dragover = (e)=>
        e.preventDefault()  if e.preventDefault
        if dropTo == @arg
          e.dataTransfer.effectAllowed = 'all'
          e.dataTransfer.dropEffect = 'copy'
        else
          e.dataTransfer.effectAllowed = 'none'
          e.dataTransfer.dropEffect = 'link'
        console.log 'dragover', @arg
        false
      _.on @el, 'dragenter', @dragenter
      _.on @el, 'dragover', @dragover
      _.on @el, 'dragleave', @dragleave
      _.on @el, 'drop', @drop
    unbind: ->
      console.log '- dropzone'
      _.off @el, 'dragenter', @dragenter
      _.off @el, 'dragover', @dragover
      _.off @el, 'dragleave', @dragleave
      _.off @el, 'drop', @drop
    update: (value, old)->
#console.log '* dropzone'
      vm = @vm
      @handler = (tag, data)->
        vm.$droptag = tag
        vm.$dropdata = data
        res = value(tag, data)
        vm.$droptag = null
        vm.$dropdata = null
        return res


new Vue(app)