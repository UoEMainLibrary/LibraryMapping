$(document).on('admin#map:loaded', function(){

    /* ------- CANVAS PROPERTIES ------- */
    var floor = $('body').data().floor;
    var library = $('body').data().library;
    $('.btn-floor[data-floor='+floor+']').addClass("currentButton");

    $('#library_option').val(library);
    $('#library_option').on('change', function() {
        window.location.replace(document.location.origin + "/admin/" + this.value + "/" + floor);
    });

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

    overlay_url = "";
    switch(floor){
        case 0: overlay_url = "/assets/overlay_ml_0.png"; break;
        case 1: overlay_url = "/assets/overlay_ml_1.png"; break;
        case 2: overlay_url = "/assets/overlay_ml_2.png"; break;
        case 3: overlay_url = "/assets/overlay_ml_3.png"; break;
        case 4: overlay_url = "/assets/overlay_ml_4.png"; break;
        case 5: overlay_url = "/assets/overlay_ml_5.png"; break;
    }

    canvas.setBackgroundImage(overlay_url, canvas.renderAll.bind(canvas), {
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
    }

    for (var i = 0; i < (boundingBox.height / gridSize); i++) {
        lines.push(new fabric.Line([ 0, i * gridSize, boundingBox.width, i * gridSize], { stroke: '#ccc'})); // horizontal lines
    }

    var grid = new fabric.Group(lines, {selectable: false, evented: false});

    canvas.add(grid);

    var printQueue = [];

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
            url : "/admin/" + library + "/"+floor,
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

        obj.range_end_opt =  $("#range_end_opt").val();
        obj.range_end_digits =  $("#range_end_digits").val();
        obj.range_end_letters = $("#range_end_letters").val();

        obj.range_start_opt =  $("#range_start_opt").val();
        obj.range_start_digits =  $("#range_start_digits").val();
        obj.range_start_letters = $("#range_start_letters").val();

        obj.identifier = $("#identifier").val();

        $.ajax({
            url : "/admin/save_element/" + library + "/" + floor,
            type : "post",
            data : { element: JSON.stringify(obj) },
            success: function(data) {

                if(!obj.id) {
                    obj.id = data.next_id;
                }

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
        var progress = $.notify({
            message: 'Publication in progress...'
        },{
            type: 'warning',
            allow_dismiss: false,
            delay: 20000,
            offset: 10
        });
        var w = canvas.width;
        var h = canvas.height;
        var z = canvas.viewport.zoom;
        var x = canvas.viewport.position.x;
        var y = canvas.viewport.position.y;


        canvas.setZoom(1);

        canvas.setWidth(6003);
        canvas.setHeight(4003);

        canvas.viewport.position.x = 0;
        canvas.viewport.position.y = 0;

        canvas.renderAll();

        canvas.remove(grid);
        removeWallCircles();
        canvas.setBackgroundImage(null, canvas.renderAll.bind(canvas));
        canvas.renderAll();


        var data = canvas.toSVG();
        var data2 = canvas.toDataURL().replace(/^data:image\/(png|jpg);base64,/, "");

        $.ajax({
            url : "/admin/save_svg/" + library + "/"+floor,
            type : "post",
            data : {
                svg_data: data,
                png_data: data2
            },
            success: function() {
                progress.update('type', 'success');
                progress.update('message', 'The canvas has been published successfully! <br> Check the live version by clicking <a href="/QA1234">here</a>.');

                setTimeout(function() {
                    progress.close();
                }, 5000);
            }
        });

        canvas.setBackgroundImage(overlay_url, canvas.renderAll.bind(canvas), {
            width: 6000,
            height: 4000,
            opacity: 0.3
        });
        restoreWallCircles();

        canvas.setZoom(z);

        canvas.setWidth(w);
        canvas.setHeight(h);

        canvas.viewport.position.x = x;
        canvas.viewport.position.y = y;

        canvas.add(grid);
        canvas.sendToBack(grid);

        canvas.renderAll();
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
                        library: this.library,
                        element_type_id: this.element_type_id,
                        modified: this.modified,
                        element_type_name: this.element_type_name
                    };

                    if (assetName == "Shelf") {
                        $.extend(opts, {
                            identifier: this.identifier,
                            range_end_opt: this.range_end_opt,
                            range_end_digits: this.range_end_digits,
                            range_end_letters:this.range_end_letters,
                            range_start_opt: this.range_start_opt,
                            range_start_digits: this.range_start_digits,
                            range_start_letters: this.range_start_letters
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
                    library: library,
                    element_type_id: parseInt(assetId),
                    modified: true,
                    id: null,
                    element_type_name: assetName
                })
                .setCoords();

            if (assetName == "Shelf") {
                loadedObject.set({
                    range_end_opt: "",
                    range_end_digits: "",
                    range_end_letters: "",
                    range_start_opt: "",
                    range_start_digits: "",
                    range_start_letters: "",
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
        var wall = new Wall(null, element_type_id, floor, library, left, top, null, null);
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

    selectShelf = function(id) {
        var shelf = canvas.getObjects().find(function(o) {return o.id == id});
        canvas.setActiveObject(shelf);
        canvas.setZoom(0.78);
        canvas.viewport.position.x = (- shelf.left * canvas.viewport.zoom) + ( canvas.width * canvas.viewport.zoom / 2);
        canvas.viewport.position.y = (- shelf.top * canvas.viewport.zoom) + ( canvas.height * canvas.viewport.zoom / 2);

        canvas.renderAll();
    };

    openEditShelf = function(id) {
        selectShelf(id);
        $('#controls_tab').tab('show');
    };

    printRanges = function() {
        $(".print_col").show();
    };

    printThis = function() {

        var count = $(".print_col input:checked").length;

        if (count == 2) {
            console.log($(".print_col input:checked:eq(0)").data("id"));
            console.log($(".print_col input:checked:eq(1)").data("id"));
            var element1 = canvas.getObjects().find(function(o) {return o.id == $(".print_col input:checked:eq(0)").data("id")});
            var element2 = canvas.getObjects().find(function(o) {return o.id == $(".print_col input:checked:eq(1)").data("id")});

            var doc = new jsPDF();
            doc.text(20, 20, element1.range_start_opt + ' ' + element1.range_start_letters + ' ' + element1.range_start_digits);
            doc.text(20, 30, element1.range_end_opt + ' ' + element1.range_end_letters + ' ' + element1.range_end_digits);

            doc.text(150, 20, element2.range_start_opt + ' ' + element2.range_start_letters + ' ' + element2.range_start_digits);
            doc.text(150, 30, element2.range_end_opt + ' ' + element2.range_end_letters + ' ' + element2.range_end_digits);

            doc.addPage();

            doc.text(20, 20, element2.range_start_opt + ' ' + element2.range_start_letters + ' ' + element2.range_start_digits);
            doc.text(20, 30, element2.range_end_opt + ' ' + element2.range_end_letters + ' ' + element2.range_end_digits);

            doc.text(150, 20, element1.range_start_opt + ' ' + element1.range_start_letters + ' ' + element1.range_start_digits);
            doc.text(150, 30, element1.range_end_opt + ' ' + element1.range_end_letters + ' ' + element1.range_end_digits);

            doc.save('Shelfmarks.pdf');

            printQueue = [];
            $(".print_col input").prop( "checked", false );
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
            } else if (activeGroup) {
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

                clipboardGroup.forEachObject(function(o) {
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
        } else if (e.shiftKey) {
            movementDelta = 2;
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
                url: "/admin/" + library + "/" + floor,
                type: "delete",
                data: {element_id: options.target.id},
                success: function(){
                    $.notify({
                        message: 'Element removed successfully from records!'
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
            $("#range_end_opt").val(options.target.range_end_opt);
            $("#range_end_letters").val(options.target.range_end_letters);
            $("#range_end_digits").val(options.target.range_end_digits);

            $("#range_start_opt").val(options.target.range_start_opt);
            $("#range_start_letters").val(options.target.range_start_letters);
            $("#range_start_digits").val(options.target.range_start_digits);

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

    // $('.edit').click(function(){
    //     canvas.isGrabMode = false;
    //     return false;
    // });
    $('#mode').click(function(){
        if($('.mode-button').hasClass('grab')){
            canvas.isGrabMode = false;
            $('.mode-button').html('Edit');
            $('.mode-button').animate({
                left: "-=40px"
            })
            $('.mode-button').removeClass('grab');
            return false;
        }else{
            canvas.isGrabMode = true;
            $('.mode-button').html('Grab');
            $('.mode-button').animate({
                left: "+=40px"
            })
            $('.mode-button').addClass('grab');
            return true;
        }
    })

    $('#gridCheckbox').click(function(){
        if (!$('.switch-button-button').hasClass('checked')) {
            canvas.add(grid);
            canvas.sendToBack(grid);
            gridEnabled = true;
            $('.switch-button-background').css('background', '#1ABB9C');
            $('.switch-button-button').animate({
                left: "+=20px"
            })
            $('.switch-button-button').addClass('checked');
        } else {
            canvas.remove(grid);
            gridEnabled = false;
            $('.switch-button-background').css('background', '#fff');
            $('.switch-button-button').animate({
                left: "-=20px"
            })
            $('.switch-button-button').removeClass('checked');
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
                        library: this.library,
                        element_type_id: this.element_type_id,
                        modified: this.modified,
                        element_type_name: this.element_type_name
                    };
                    if (element_type == "Shelf") {
                        $.extend(opts, {
                            identifier: this.identifier,
                            range_end_opt: this.range_end_opt,
                            range_end_digits: this.range_end_digits,
                            range_end_letters:this.range_end_letters,
                            range_start_opt: this.range_start_opt,
                            range_start_digits: this.range_start_digits,
                            range_start_letters: this.range_start_letters
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
                    library: element.library,
                    modified: false,
                    element_type_id: element.element_type_id,
                    element_type_name: element_type
                })
                .setCoords();

            if (element_type == "Shelf") {
                loadedObject.set({
                    range_end_opt: element.range_end_opt,
                    range_end_digits: element.range_end_digits,
                    range_end_letters: element.range_end_letters,
                    range_start_opt: element.range_start_opt,
                    range_start_digits: element.range_start_digits,
                    range_start_letters: element.range_start_letters,
                    identifier: element.identifier,
                    originX: 'center',
                    originY: 'center'
                })

                $('#shelves-table > tbody:last-child').append('' +
                    '<tr>' +
                        '<td>' + element.id + '</td>' +
                        '<td style="color: white; background-color:'+get_rgb(element.range_start)+'">' + element.range_start_opt + ' ' + element.range_start_letters + ' ' + element.range_start_digits+ '</td>' +
                        '<td style="color: white; background-color:'+get_rgb(element.range_end)+'">' + element.range_end_opt + ' ' + element.range_end_letters + ' ' + element.range_end_digits+ '</td>' +
                        '<td><a href="#" onclick="openEditShelf('+element.id+')">Edit</a></td>' +
                        '<td><a href="#" onclick="selectShelf('+element.id+')">Select</a></td>' +
                        '<td class="print_col" style="display: none"><input type="checkbox" data-id="'+element.id+'" onclick="printThis()"></td>' +
                    '</tr>');

            }
            canvas.add(loadedObject);
            if (counter == last) {
                canvas.renderOnAddRemove = true;
                canvas.renderAll();
                $('#loading-container').hide();
                $('#canvas-container').fadeIn(500);
                console.log("renderOnAddRemove")
            }
            counter++;
        });
    } else {
        counter++;
        var wall = new Wall(element.id, element.element_type_id, element.floor, element.library, element.top, element.right, element.left, element.bottom);
        wall.addTo(canvas);
        wallCircles.push(wall.circle1, wall.circle2);

    }
}


/* ------- WALL ------- */
function Wall(id, element_type_id, floor, library, left, top, right, bottom) {
    if (!right || !bottom) {
        right = left + 100;
        bottom = top + 100;
    }

    this.wall = makeLine([left, top, right, bottom]);

    this.wall.toObject = (function (toObject) {
        return function () {
            var opts = {
                id: this.id,
                floor: this.floor,
                library: this.library,
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
            library: library,
            element_type_id: element_type_id,
            modified: id ? false : true,
            id: id,
            element_type_name: "Wall"
        })
        .setCoords();

    this.addTo = function(canvas) {
        canvas.add(this.wall);

        this.circle1 = makeCircle(this.wall.get('x1'), this.wall.get('y1'), null, this.wall);
        this.circle2 = makeCircle(this.wall.get('x2'), this.wall.get('y2'), this.wall, null);

        canvas.add(this.circle1, this.circle2);
    }
}

function makeLine(coords) {
    return new fabric.Line(coords, {
        fill: '#333',
        stroke: '#333',
        strokeWidth: 5,
        selectable: false,
        originX: 'center',
        originY: 'center'
    });
}

function makeCircle(left, top, line1, line2) {
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

get_rgb = function(value) {
    var minimum = 1000;
    var maximum = 1600;
    var ratio = 2 * (value - minimum) / (maximum - minimum);
    var b = Math.round(Math.max(0, 255*(1 - ratio)));
    var r = Math.round(Math.max(0, 255*(ratio - 1)));
    var g = 255 - b - r;
    return "rgb(" + r + ", " + g + ", " + b + ")";
}