window.parent_child_push = function(parent_id, child_id, color)
{
    parent_child.push([
      parent_id,
      child_id,
      color
    ])
}

window.line_push = function(parent_id, child_id, color)
{
    
    var ddx = 0;
    var ddy = 0;
    var parent = $(parent_id);
    var child = $(child_id);
    if (parent == null || child == null)
        return;
    lines.push([
      parent.cumulativeOffset()[0] + parent.getWidth() + ddx,
      parent.cumulativeOffset()[1] + parent.getHeight()/2 + ddy,
      child.cumulativeOffset()[0] + ddx,
      child.cumulativeOffset()[1] + child.getHeight()/2 + ddy,
      color
    ])
}

window.lines_push = function()
{
    for (var i = 0; i < parent_child.length; i++)
    {
        line_push(parent_child[i][0], parent_child[i][1], parent_child[i][2])
    }
}

window.add_lines_for_doubles = function(parent_id, child_id, color)
{
        var parent = $(parent_id).up();
        var child = $(child_id).up();


        x_parent = parent.cumulativeOffset()[0];
        y_parent = parent.cumulativeOffset()[1];

        w_parent = parent.getWidth();
        h_parent = parent.getHeight();

        x_child = child.cumulativeOffset()[0];
        y_child = child.cumulativeOffset()[1];

        w_child = child.getWidth();
        h_child = child.getHeight();

        x_start = x_child + w_child/2
        y_start = y_child + h_child/2

        x_end = x_parent + w_parent/2
        y_end = y_parent + h_parent/2

        if (x_start > x_end)
        {
          x_start -= (w_child/2 + 5);
          x_end += (w_parent/2 + 5);
        }
        else
        {
          x_start += (w_child/2 + 5);
          x_end -= (w_parent/2 + 5);
        }

        if (y_start > y_end)
        {
          y_start -= (h_child/2 + 5);
          y_end += (h_parent/2 + 5);
        }
        else
        {
          y_start += (h_child/2 + 5);
          y_end -= (h_parent/2 + 5);
        }


        double_lines.push([
          x_start,
          y_start,

          (x_end + (x_start - x_end)/1.5),
          y_start,

          (x_start - (x_start - x_end)/1.5),
          y_end,

          x_end,
          y_end,
          color
        ]);

}

window.draw_connectors = function()
{
    lines.clear();
    lines_push();

    var table = $("structure-table");

    if (window.r != null)
        window.r.remove();
    
    window.r = Raphael(0, 0, table.getWidth()+table.cumulativeOffset()[1], table.getHeight()+table.cumulativeOffset()[1]), discattr = {fill: "#fff", stroke: "none"};

    function curve(x, y, ax, ay, bx, by, zx, zy, color) {
        var path = [["M", x, y], ["C", ax, ay, bx, by, zx, zy]],
            curve = r.path(path).attr({stroke: color || Raphael.getColor(), "stroke-width": 2, "stroke-linecap": "round"}),
            c = r.set();
    }

    function curve_dashed(x, y, ax, ay, bx, by, zx, zy, color) {
        var path = [["M", x, y], ["C", ax, ay, bx, by, zx, zy]],
            curve = r.path(path).attr({stroke: color || Raphael.getColor(), "stroke-width": 2, "stroke-linecap": "round", "stroke-dasharray": ". "  }),
            c = r.set();
    }

    var dx = 50
    var dy = 50

    for (var i =0; i < lines.length; i++){
      if (lines[i][0] == 0 || lines[i][1] == 0 || lines[i][2] == 0 || lines[i][3] == 0)
          continue;
      x1 = lines[i][0]+3
      y1 = lines[i][1]
      x2 = lines[i][2]-3
      y2 = lines[i][3]
      color = lines[i][4]
      curve(x1, y1, x1+dx, y1, x2-dx, y2, x2, y2, color);
    }

    dx = 50;
    for (i =0; i < double_lines.length; i++){
      x_start = double_lines[i][0]
      y_start = double_lines[i][1]

      x_p_start = double_lines[i][2]
      y_p_start = double_lines[i][3]

      x_p_end = double_lines[i][4]
      y_p_end = double_lines[i][5]

      x_end = double_lines[i][6]
      y_end = double_lines[i][7]

      color = double_lines[i][8]
      curve_dashed(x_start, y_start, x_p_start, y_p_start, x_p_end, y_p_end, x_end, y_end, color);
    }

}
