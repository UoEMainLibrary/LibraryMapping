$(document).on('admin#map:loaded', function(){

  /* ------- CANVAS PROPERTIES ------- */
  var floor = $('body').data().floor;

  var boundingBox = new fabric.Rect({
    fill: "transparent",
    width: 6000,
    height: 4000,
    hasBorders: false,
    hasControls: false,
    lockMovementX: true,
    lockMovementY: true,
    evented: false,
    selectable: false,
    stroke: "#333"
  });

  canvas.add(boundingBox);

  canvas.svgViewportTransformation = false;
  canvas.renderOnAddRemove = false;

  canvas.setBackgroundColor('#fff', function () {
    canvas.renderAll();
  });


  canvas.setBackgroundImage("/assets/overlay_ml_1.png", canvas.renderAll.bind(canvas), {
    width: 6000,
    height: 4000,
    opacity: 0.3
  });

  wallCircles = [];

  var minZoom = canvas.width / boundingBox.width;
  canvas.viewport.zoom = minZoom;
  $("#zoomSlider").attr("min", minZoom);
  $("#zoomSlider").val(minZoom);
  $(".progress-bar").css("width", $("#zoomSlider").val());

  var gridSize = 20;

  var gridEnabled = true;
  var lines = [];
  for (var i = 0; i < (boundingBox.width / gridSize); i++) {
    lines.push(new fabric.Line([ i * gridSize, 0, i * gridSize, boundingBox.height], { stroke: '#ccc'})); // vertical lines
    lines.push(new fabric.Line([ 0, i * gridSize, boundingBox.width, i * gridSize], { stroke: '#ccc'})) // horizontal lines
  }

  var grid = new fabric.Group(lines, {selectable: false, evented: false});

  canvas.add(grid)

  /* ------- CANVAS METHODS ------- */

  saveCanvas = function() {
    canvas.deactivateAll();
    removeWallCircles();

    var obj = canvas.getObjects().filter(function(o) {
      return o.modified == true
    } );

    console.log(JSON.stringify(obj));
    restoreWallCircles();

    return $.ajax({
      url : "/admin/"+floor,
      type : "post",
      data : { elements: JSON.stringify(obj) },
      success: function(data, textStatus, xhr) {
        var idCount = data.next_id;
        obj.forEach(function(o) {
          o.modified = false;
          if (!o.id) {
            o.id = idCount;
            idCount++;
          }
        });
        $.notify({
          message: 'The canvas has been saved successfully!',
        },{
          type: 'success',
          offset: 10
        });
      }
    });
  };

  saveElementData = function () {
    var obj = canvas.getActiveObject();

    obj.range_up_opt =  $("#range_up_opt").val();
    obj.range_up_digits =  $("#range_up_digits").val();
    obj.range_up_letters = $("#range_up_letters").val();

    obj.range_down_opt =  $("#range_down_opt").val();
    obj.range_down_digits =  $("#range_down_digits").val();
    obj.range_down_letters = $("#range_down_letters").val();

    obj.classification =  $("#classification").val();
    obj.identifier = $("#identifier").val();

    $.ajax({
      url : "/admin/save_element/" + floor,
      type : "post",
      data : { element: JSON.stringify(obj) },
      success: function() {
        $.notify({
          message: 'Shelf attributes saved successfully!'
        },{
          type: 'success',
          offset: 10
        });
      },
      error: function(xhr) {

        var errors = $.parseJSON(xhr.responseText).errors;
        $.notify({
          message: errors
        },{
          type: 'danger',
          offset: 10
        });
      }
    });
  };


  removeSelected = function() {
    var activeObject = canvas.getActiveObject(),
        activeGroup = canvas.getActiveGroup();

    if ((activeObject || activeGroup) && confirm('Are you sure?')) {
      var toRemove = [];

      if (activeGroup) {
        toRemove = activeGroup.getObjects();
        canvas.discardActiveGroup();
      } else if (activeObject) {
        toRemove.push(activeObject);
      }

      toRemove.forEach(function(object) {
        if (object.type != "circle") {
          canvas.remove(object);
        } else {
          // If wall
          canvas.remove(object.line1);
          canvas.remove(object.line2);
          for (var i=0; i < wallCircles.length; i++) {
            if (object.line1) {
              if (wallCircles[i].line1 == object.line1 || wallCircles[i].line2 == object.line1) {
                canvas.remove(wallCircles[i]);
              }
            } else if (object.line2) {
              if (wallCircles[i].line1 == object.line2 || wallCircles[i].line2 == object.line2) {
                canvas.remove(wallCircles[i]);
              }
            }
          }
        }
      });

    }
  };

  rasterizeSVG = function() {
    var w = canvas.width;
    var h = canvas.height;

    canvas.width = 6003;
    canvas.height = 4003;
    canvas.remove(grid);
    removeWallCircles();

    var data = canvas.toSVG();
    $.ajax({
      url : "/admin/save_svg/"+floor,
      type : "post",
      data : { svg_data: data },
      success: function() {
        //TODO: update url
        $.notify({
          message: 'The canvas has been published successfully! <br> Check the live version by clicking on this notification.',
          url: "/QA1231",
          target: "_self"
        },{
          type: 'success',
          offset: 10
        });
      }
    });

    restoreWallCircles();
    canvas.width = w;
    canvas.height = h;
    canvas.add(grid);
    canvas.sendToBack(grid);
  };

  addShape = function(assetId, assetName, assetPath) {
    var coord = {
      left: (- canvas.viewport.position.x / canvas.viewport.zoom) + ( canvas.width / canvas.viewport.zoom / 2),
      top: (- canvas.viewport.position.y / canvas.viewport.zoom) + ( canvas.height / canvas.viewport.zoom / 2)
    };

    fabric.loadSVGFromURL(assetPath, function(objects, options) {

      var loadedObject = fabric.util.groupSVGElements(objects, options);
      loadedObject.toObject = (function (toObject) {
        return function () {
          var opts = {
            id: this.id,
            floor: this.floor,
            element_type_id: this.element_type_id,
            modified: this.modified,
            element_type_name: this.element_type_name
          };

          if (assetName == "Shelf") {
            $.extend(opts, {
              classification: this.classification,
              identifier: this.identifier,
              range_up_opt: this.range_up_opt,
              range_up_digits: this.range_up_digits,
              range_up_letters:this.range_up_letters,
              range_down_opt: this.range_down_opt,
              range_down_digits: this.range_down_digits,
              range_down_letters: this.range_down_letters
            })
          }
          return fabric.util.object.extend(toObject.call(this), opts);
        };
      })(fabric.Object.prototype.toObject);

      loadedObject.set({
            left: coord.left,
            top: coord.top,
            angle: 0,
            floor: floor,
            element_type_id: parseInt(assetId),
            modified: true,
            id: null,
            element_type_name: assetName
          })
          .setCoords();

      if (assetName == "Shelf") {
        loadedObject.set({
          range_up_opt: "",
          range_up_digits: "",
          range_up_letters: "",
          range_down_opt: "",
          range_down_digits: "",
          range_down_letters: "",
          classification: "",
          identifier: "",
          originX: 'center',
          originY: 'center'
        })
      }

      canvas.add(loadedObject);
    });
  };

  addWall = function(element_type_id) {
    var left = (- canvas.viewport.position.x / canvas.viewport.zoom) + ( canvas.width / canvas.viewport.zoom / 2)
    var top = (- canvas.viewport.position.y / canvas.viewport.zoom) + ( canvas.height / canvas.viewport.zoom / 2)
    var wall = new Wall(null, element_type_id, floor, left, top, null, null);
    wall.addTo(canvas);
    wallCircles.push(wall.circle1, wall.circle2);
  };


  removeWallCircles = function() {
    for(var i=0; i < wallCircles.length; i++) {
      wallCircles[i].setOpacity(0);
    }
  };

  restoreWallCircles = function() {
    for(var i=0; i < wallCircles.length; i++) {
      wallCircles[i].setOpacity(1);
    }
  };

  /* ------- EVENT LISTENERS ------- */

  var clipboardObj, clipboardGroup;
  var movementDelta = 2;

  $(document).on("keydown", function(e) {
    var activeObject = canvas.getActiveObject();
    var activeGroup = canvas.getActiveGroup();

    if (e.keyCode == 67 && (e.ctrlKey || e.metaKey)) {
      // Copy
      if (activeObject) {
        clipboardObj = activeObject;
      } else if (group) {
        clipboardGroup = activeGroup;
      }
    } else if (e.keyCode == 86 && (e.ctrlKey || e.metaKey)) {
      // Paste
      if (clipboardObj) {
        var clone = fabric.util.object.clone(clipboardObj);
        clone.set({
          left: clipboardObj.left + 30,
          top: clipboardObj.top + 30
        });

        clone.id = null;
        clone.modified = true;

        canvas.add(clone);
        canvas.deactivateAll().renderAll();
        canvas.setActiveObject(clone);
      } else if (clipboardGroup) {
        canvas.deactivateAll();

        clipboardGroup.forEach(function(o) {
          var clone = fabric.util.object.clone(o);
          clone.set({
            left: o.left + 30,
            top: o.top + 30
          }).setCoords();

          clone.id = null;
          clone.modified = true;
          canvas.add(clone);
        });

        canvas.renderAll();
      }
    } else if (e.keyCode == 18) {
      // Shift
      canvas.isGrabMode = true;
    } else if (e.keyCode >= 37 && e.keyCode <= 40) {
      // Arrow keys
      if (e.shiftKey) {
        movementDelta = 20;
      }
      e.preventDefault();
      var target = activeObject || activeGroup;
      switch(e.keyCode) {
        case 37:
          target.set('left', target.get('left') - movementDelta);
          break;
        case 38:
          target.set('top', target.get('top') - movementDelta);
          break;
        case 39:
          target.set('left', target.get('left') + movementDelta);
          break;
        case 40:
          target.set('top', target.get('top') + movementDelta);
          break;
        default:
          break;
      }
    } else if(e.keyCode == 46) {
      // Delete
      removeSelected()
    }

    if (activeObject) {
      activeObject.setCoords();
      activeObject.modified = true;
    } else if (activeGroup) {
      activeGroup.setCoords();
      activeGroup.forEachObject(function(o) {
        o.modified = true;
      });
    }
    canvas.renderAll();
  });

  $(document).on('keyup', function(e) {
    if(e.keyCode==18) {
      canvas.isGrabMode = false;
    }
  });

  var canvas_container = document.getElementById('canvas-container');
  canvas_container.addEventListener('DOMMouseScroll', handleScroll, false);
  canvas_container.addEventListener('mousewheel', handleScroll, false);

  function handleScroll(e) {
    var delta = e.wheelDelta ? e.wheelDelta/40 : e.detail ? -e.detail : 0;
    if (delta > 0) {
      var newZoom = canvas.viewport.zoom / 1.1;
      if (newZoom >= minZoom) {
        canvas.setZoom(newZoom);
        $("#zoomSlider").val(newZoom);
      }
    } else if (delta < 0) {
      var newZoom = canvas.viewport.zoom * 1.1;
      if (newZoom <= 1.5) {
        canvas.setZoom(newZoom);
        $("#zoomSlider").val(newZoom);
      }
    }
    return e.preventDefault() && false;
  }

  canvas.on('object:modified', function(options) {
    var toModify = [];
    if (options.target._objects) {
      toModify = options.target._objects;
    } else {
      toModify.push(options.target);
    }

    toModify.forEach(function(o) {
      if (o.type != "circle") {
        o.modified = true;
      } else {
        if (o.line1) {
          o.line1.modified = true;
        } else {
          o.line2.modified = true;
        }
      }
    });
  });

  canvas.on('object:removed', function(options){
    if(options.target.id) {
      $.ajax({
        url: "/admin/" + floor,
        type: "delete",
        data: {element_id: options.target.id},
        success: function(){
          $.notify({
            message: 'Element(s) remove successfully from records!'
          },{
            type: 'success',
            offset: 10
          });
          }
      });
    }
  });

  canvas.on('object:rotating', function(options) {
    if (options.e.shiftKey) {
      options.target.angle = options.target.angle - options.target.angle % 45
    }
  });

  canvas.on('object:selected', function(options){
    $("#remove-selected").css("display", "initial");
    $("#shelfData").css("display", "none");

    if(options.target.element_type_name == "Shelf") {
      $("#shelfData").css("display", "initial");
      $("#range_up_opt").val(options.target.range_up_opt);
      $("#range_up_letters").val(options.target.range_up_letters);
      $("#range_up_digits").val(options.target.range_up_digits);

      $("#range_down_opt").val(options.target.range_down_opt);
      $("#range_down_letters").val(options.target.range_down_letters);
      $("#range_down_digits").val(options.target.range_down_digits);

      $("#classification").val(options.target.classification);
      $("#identifier").val(options.target.identifier);
    }
  });

  canvas.on('selection:cleared', function(options){
    $("#remove-selected").css("display", "none");
    $("#shelfData").css("display", "none");
  });

  canvas.on("object:moving", function(e) {
    var obj = e.target;
    var top = obj.top;
    var left = obj.left;
    var zoom = canvas.viewport.zoom;

    // width & height we are constraining to must be calculated by applying the inverse of the current viewportTransform
    var c_width = canvas.width / zoom;
    var c_height = canvas.height / zoom;

    var w = obj.width * obj.scaleX;
    var h = obj.height * obj.scaleY;

    var top_bound = boundingBox.top;
    var bottom_bound = boundingBox.top + boundingBox.height - h;
    var left_bound = boundingBox.left;
    var right_bound = boundingBox.left + boundingBox.width - w;

    if( w > c_width ) {
      obj.setLeft(left_bound);
    } else {
      if (gridEnabled) {
        obj.setLeft(Math.min(Math.max(Math.round(left / gridSize) * gridSize, left_bound), right_bound));
      } else {
        obj.setLeft(Math.min(Math.max(left, left_bound), right_bound));
      }
    }

    if( h > c_height ) {
      obj.setTop(top_bound);
    } else {
      if (gridEnabled) {
        obj.setTop(Math.min(Math.max(Math.round(top / gridSize) * gridSize, top_bound), bottom_bound));
      } else {
        obj.setTop(Math.min(Math.max(top, top_bound), bottom_bound));
      }
    }
  });

  canvas.on('object:moving', function(e) {
    var p = e.target;
    p.line1 && p.line1.set({ 'x2': p.left, 'y2': p.top });
    p.line2 && p.line2.set({ 'x1': p.left, 'y1': p.top });
    canvas.renderAll();
  });

  /* ------- UI LISTENERS ------- */

  $('#zoomIn').click(function() {
    var newZoom = canvas.viewport.zoom * 1.1;
    if (newZoom <= 1.5) {
      canvas.setZoom(newZoom);
      $("#zoomSlider").val(newZoom);
    }
    return false;
  });

  $('#zoomOut').click(function(){
    var newZoom = canvas.viewport.zoom / 1.1;
    if (newZoom >= minZoom) {
      canvas.setZoom(newZoom);
      $("#zoomSlider").val(newZoom);
    }
    return false;
  });

  $('#zoomSlider').on('input', function() {
    canvas.setZoom($(this).val());
    if (canvas.viewport.position.x > 0) {
      canvas.viewport.position.x = 0;
    }
    if (canvas.viewport.position.y > 0) {
      canvas.viewport.position.y = 0;
    }
    canvas.renderAll();
  });

  $('.edit').click(function(){
    canvas.isGrabMode = false;
    return false;
  });

  $('#gridCheckbox').click(function(){
    if ($(this).prop('checked')) {
      canvas.add(grid);
      canvas.sendToBack(grid);
      gridEnabled = true;
    } else {
      canvas.remove(grid);
      gridEnabled = false;
    }
  });

  $(document).trigger('canvas:preloaded');
});




var counter = 1;
function loadElementInCanvas(element, element_type, svg_path, last) {
  if (element_type != "Wall") {
    var shape = svg_path;

    fabric.loadSVGFromURL(shape, function(objects, options) {
      var loadedObject = fabric.util.groupSVGElements(objects, options);

      loadedObject.toObject = (function (toObject) {
        return function () {
          var opts = {
            id: this.id,
            floor: this.floor,
            element_type_id: this.element_type_id,
            modified: this.modified,
            element_type_name: this.element_type_name
          };
          if (element_type == "Shelf") {
            $.extend(opts, {
              classification: this.classification,
              identifier: this.identifier,
              range_up_opt: this.range_up_opt,
              range_up_digits: this.range_up_digits,
              range_up_letters:this.range_up_letters,
              range_down_opt: this.range_down_opt,
              range_down_digits: this.range_down_digits,
              range_down_letters: this.range_down_letters
            })
          }
          return fabric.util.object.extend(toObject.call(this), opts);
        };
      })(fabric.Object.prototype.toObject);

      loadedObject.set({
            left: element.left,
            top: element.top,
            scaleX: element.scaleX,
            scaleY: element.scaleY,
            opacity: element.opacity,
            angle: element.angle,
            fill: element.fill,
            id: element.id,
            floor: element.floor,
            modified: false,
            element_type_id: element.element_type_id,
            element_type_name: element_type
          })
          .setCoords();

      if (element_type == "Shelf") {
        loadedObject.set({
          range_up_opt: element.range_up_opt,
          range_up_digits: element.range_up_digits,
          range_up_letters: element.range_up_letters,
          range_down_opt: element.range_down_opt,
          range_down_digits: element.range_down_digits,
          range_down_letters: element.range_down_letters,
          classification: element.classification,
          identifier: element.identifier,
          originX: 'center',
          originY: 'center'
        })
      }
      canvas.add(loadedObject);
      if (counter == last) {
        canvas.renderOnAddRemove = true;
        canvas.renderAll();
        console.log("renderOnAddRemove")
      }
      counter++;
    });
  } else {
    counter++;
    var wall = new Wall(element.id, element.element_type_id, element.floor, element.top, element.right, element.left, element.bottom);
    wall.addTo(canvas);
    wallCircles.push(wall.circle1, wall.circle2);

  }
}


/* ------- WALL ------- */
class Wall {
  constructor(id, element_type_id, floor, left, top, right, bottom) {
    if (!right || !bottom) {
      right = left + 100;
      bottom = top + 100;
    }

    this.wall = Wall.makeLine([left, top, right, bottom]);

    this.wall.toObject = (function (toObject) {
      return function () {
        var opts = {
          id: this.id,
          floor: this.floor,
          element_type_id: this.element_type_id,
          modified: this.modified,
          element_type_name: this.element_type_name,
          top: this.x1,
          left: this.x2,
          right: this.y1,
          bottom: this.y2
        };

        return fabric.util.object.extend(toObject.call(this), opts);
      }
    })(fabric.Object.prototype.toObject);


    this.wall.set({
          floor: floor,
          element_type_id: element_type_id,
          modified: id ? false : true,
          id: id,
          element_type_name: "Wall"
        })
        .setCoords();
  }

  addTo(canvas) {
    canvas.add(this.wall);

    this.circle1 = Wall.makeCircle(this.wall.get('x1'), this.wall.get('y1'), null, this.wall);
    this.circle2 = Wall.makeCircle(this.wall.get('x2'), this.wall.get('y2'), this.wall, null);

    canvas.add(this.circle1, this.circle2);
  }

  static makeLine(coords) {
    return new fabric.Line(coords, {
      fill: '#333',
      stroke: '#333',
      strokeWidth: 5,
      selectable: false,
      originX: 'center',
      originY: 'center'
    });
  }

  static makeCircle(left, top, line1, line2) {
    var c = new fabric.Circle({
      left: left,
      top: top,
      strokeWidth: 5,
      radius: 12,
      fill: '#fff',
      stroke: '#666',
      originX: 'center',
      originY: 'center'
    });
    c.hasControls = c.hasBorders = false;

    c.line1 = line1;
    c.line2 = line2;

    return c;
  }
}