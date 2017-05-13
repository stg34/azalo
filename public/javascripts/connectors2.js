window.line_push = function(parent, child, color)
{
    var ddx = 0;
    var ddy = 0;
    if (parent == null || child == null){
        return;
    }

    if (parent == undefined || child == undefined){
        return;
    }

    window.lines.push([
      parent.cumulativeOffset()[0] + parent.getWidth() + ddx,
      parent.cumulativeOffset()[1] + parent.getHeight()/2 + ddy,
      child.cumulativeOffset()[0] + ddx,
      child.cumulativeOffset()[1] + child.getHeight()/2 + ddy,
      color
    ])
}

window.draw_connectors = function()
{
    
    var class_page_box = '.page-box';
    var i = 0;

    var boxes = $$(class_page_box);
    
    
    if(window.lines == undefined)
      window.lines = [];
    
    window.lines.clear();

    for(i = 0; i < boxes.length; i++)
    {
        var box = boxes[i];
        var t1 = box.up('.structure-table');
        var r1 = t1.up('.structure-row');
        //var r1 = box.up('.structure-row');
        if (r1 == undefined)
            continue;
        var box2 = r1.down(class_page_box);
        
        var color = "rgb(255, 213, 170)";
        if(box.hasClassName('component'))
            color = "rgb(189, 219, 237)";

        window.line_push(box2, box, color);
    }

    //return;
    var table = $("structure-table");

    if (window.r != null)
        window.r.remove();
    
    window.r = Raphael(0, 0, table.getWidth()+table.cumulativeOffset()[1], table.getHeight()+table.cumulativeOffset()[1]), discattr = {fill: "#fff", stroke: "none"};

    function curve(x, y, ax, ay, bx, by, zx, zy, color) {
        
        var path = [["M", x, y], ["C", ax, ay, bx, by, zx, zy]],
            curve = r.path(path).attr({stroke: color || Raphael.getColor(), "stroke-width": 1, "stroke-linecap": "round"}),
            c = r.set();
    }

    /*function curve_dashed(x, y, ax, ay, bx, by, zx, zy, color) {
        var path = [["M", x, y], ["C", ax, ay, bx, by, zx, zy]],
            curve = r.path(path).attr({stroke: color || Raphael.getColor(), "stroke-width": 1, "stroke-linecap": "round", "stroke-dasharray": ". "  }),
            c = r.set();
    }*/

    var dx = 50
    var dy = 50

    for (i =0; i < window.lines.length; i++){
      var line = window.lines[i];
      if (line[0] == 0 || line[1] == 0 || line[2] == 0 || line[3] == 0)
          continue;
      x1 = line[0]+3
      y1 = line[1]
      x2 = line[2]-3
      y2 = line[3]
      color = line[4]
      curve(x1, y1, x1+dx, y1, x2-dx, y2, x2, y2, color);
    }
}
