window.parent_child_push = function(parent_id, child_id, color)
{
    window.parent_child.push([
      parent_id.toString(),
      child_id.toString(),
      color
    ])
}

window.line_push = function(parent_id, child_id, color)
{
    var ddx = 0;
    var ddy = 0;

    var parents = $$("." + parent_id);
    var childs = $$("." + child_id);

    if (parents.length == 0 || childs.length == 0)
        return;
    
    var parent = parents[0];
    var child = childs[0];

    if (parent == null || child == null){
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

window.lines_count = function(){
    alert("parent-child: " + window.parent_child.length.toString() + " lines:" + window.lines.length.toString());
}

window.lines_push = function()
{
    for (var i = 0; i < window.parent_child.length; i++)
    {
        if (window.foobar123 == 1)
        {
            alert(i);
        }
        window.line_push(window.parent_child[i][0], window.parent_child[i][1], window.parent_child[i][2])
    }
    if (window.foobar123 == 1)
      window.lines_count();
}

window.draw_connectors = function()
{
    window.lines.clear();
    window.lines_push();

    /*if (window.foobar123 == 1)
    {
        lines_count();
    }*/

    var table = $("structure-table");

    if (window.r != null)
        window.r.remove();
    
    window.r = Raphael(0, 0, table.getWidth()+table.cumulativeOffset()[1], table.getHeight()+table.cumulativeOffset()[1]), discattr = {fill: "#fff", stroke: "none"};

    function curve(x, y, ax, ay, bx, by, zx, zy, color) {
        
        var path = [["M", x, y], ["C", ax, ay, bx, by, zx, zy]],
            curve = r.path(path).attr({stroke: color || Raphael.getColor(), "stroke-width": 1, "stroke-linecap": "round"}),
            c = r.set();
    }

    function curve_dashed(x, y, ax, ay, bx, by, zx, zy, color) {
        var path = [["M", x, y], ["C", ax, ay, bx, by, zx, zy]],
            curve = r.path(path).attr({stroke: color || Raphael.getColor(), "stroke-width": 1, "stroke-linecap": "round", "stroke-dasharray": ". "  }),
            c = r.set();
    }

    var dx = 50
    var dy = 50

    for (var i =0; i < window.lines.length; i++){
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
