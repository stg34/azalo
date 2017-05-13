function expand_component_roots(element)
{
    var elements;
    var i;
    var e = element.down('.expand-controls');
    var this_expanded = false;
    if (e != undefined)
        this_expanded = e.visible();


    elements = $$('.component-heads');
    for (i = 0; i < elements.size(); i++)
    {
        elements[i].hide();
    }
    
    elements = $$('.expand-controls');
    for (i = 0; i < elements.size(); i++)
    {
        elements[i].show();
    }

    elements = $$('.collapse-controls');
    for (i = 0; i < elements.size(); i++)
    {
        elements[i].hide();
    }

    var collapse_control = element.down('.collapse-controls');
    if (collapse_control != undefined)
    {
        if(this_expanded)
            collapse_control.show();
        else
            collapse_control.hide();
    }

    var expand_control = element.down('.expand-controls');
    if (expand_control != undefined)
    {
        if(this_expanded)
            expand_control.hide();
        else
            expand_control.show();

    }

    if(this_expanded)

    var row = element.up('tr');
    if (row != undefined)
        row = row.next();
    if (row != undefined)
    {
        if(this_expanded)
            row.show();
        else
            row.hide();
            
    }
    return;
}

function operation_start(operation)
{
    var t = new Date();
    var id = t.getTime();
    if(window.operations_count == undefined)
        window.operations_count = 1;
    else
        window.operations_count++;
      
    if(window.operations_count == 1)
    {
        var spinner = $('spinner-holder');
        spinner.show();
    }

    id = id.toString();
    var oplog = $('oplog');
    if (oplog != undefined)
    {
        var stub = document.createElement('div');
        stub.id = id;

        var h = t.getHours().toString();
        var m = t.getMinutes().toString();
        var s = t.getSeconds().toString();

        stub.innerHTML = "<span class='time'>" + h + ":" + m + ":" + s + "</span> " + operation;
        oplog.insert({top: stub});
    }
    return id;
}

function operation_finish(id, status)
{
    id = id.toString();
    
    var re_error = /error/;
    var re_success = /success/;
    var result_class = "";

    if (re_error.test(status))
      result_class = "error";

    if (re_success.test(status))
      result_class = "success";

    var op = $(id);
    if (op != undefined)
    {
        op.insert(": <span class='" + result_class + "'>" + status + "</span> ");

        window.operations_count--;
        if(window.operations_count == 0)
        {
            var spinner = $('spinner-holder');
            spinner.hide();
        }
    }
}

function reset_draggables_style(page_id)
{
    var draggables;
    var i;
    draggables = $$(".page-" + page_id.toString() +  " .page-anchors");
    draggables = draggables.concat($$(".page-" + page_id.toString() +  " .page-anchor"));
    for (i = 0; i < draggables.size(); i++)
    {
        draggables[i].setStyle({left: '', opacity:'', top: '', 'z-index' : ''});
    }
}

function update_page_box(page_id)
{
    var url = '/az_pages/page_box/' + page_id.toString() + "/" + window.show_mode;
    var i;
    var op_id = operation_start('update_page_box');
    new Ajax.Request(url,
                   { method: 'get',
                        evalScripts: true,
                        asynchronous:true,
                        onSuccess: function(response) {
                            var page_holders = $$('.page_box_holder_' + page_id.toString());
                            for (i = 0; i < page_holders.length; i++)
                            {
                                page_holders[i].innerHTML = response.responseText;
                            }
                            draw_connectors();
                            add_draggables_and_dropables();
                            operation_finish(op_id, 'success');
                        },
                        onFailure: function(response) {
                            operation_finish(op_id, 'error');
                        }
                     });
}

function update_component_list(project_id)
{
    var url = '/az_projects/component_list/' + project_id.toString();
    var op_id = operation_start('update_component_list');
    new Ajax.Request(url,
                   {method: 'get',
                    evalScripts: true,
                    asynchronous:true,
                      onSuccess: function(response) {
                          $('right-block').innerHTML = response.responseText;
                          add_draggables_and_dropables();
                          operation_finish(op_id, 'success');
                      },
                      onFailure: function(response) {
                          operation_finish(op_id, 'error');
                      }
                 });
}


function update_datatype_list()
{
    var project_id = window.project_id;
    var url = '/az_base_projects/datatype_list/' + project_id.toString();
    var op_id = operation_start('update_datatype_list');
    new Ajax.Request(url,
                   {method: 'get',
                    evalScripts: true,
                    asynchronous:true,
                      onSuccess: function(response) {
                          $('right-block').innerHTML = response.responseText;
                          add_draggables_and_dropables();
                          operation_finish(op_id, 'success');
                      },
                      onFailure: function(response) {
                          operation_finish(op_id, 'error');
                      }
                 });
}

function update_tr_page(page_id)
{
  var i;
  var op_id = operation_start('update_tr_page');

  new Ajax.Request('/az_pages/page_tr/' + page_id.toString(),
           { method: 'get',
             evalScripts: true,
             asynchronous:true,
             onSuccess: function(response) {
                var page_holders = $$('.tr-page-text-' + page_id.toString());
                for (i = 0; i < page_holders.size(); i++)
                    page_holders[i].innerHTML = response.responseText;

                operation_finish(op_id, 'success');
             },
              onFailure: function(response) {
                  operation_finish(op_id, 'error');
              }
           });
}

function update_toc_tr_page_status_color(page_id)
{
  var i;
  var op_id = operation_start('update_toc_tr_page_status_color');

  new Ajax.Request('/az_pages/tr_page_status_color/' + page_id.toString(),
           { method: 'get',
             evalScripts: true,
             asynchronous:true,
             onSuccess: function(response) {
               var l3 = $('l3-' + page_id.toString());
               if (l3 != undefined)
               {
                    l3.setStyle({ borderRightColor: response.responseText });
               }
                operation_finish(op_id, 'success');
             },
              onFailure: function(response) {
                  operation_finish(op_id, 'error');
              }
           });
}


function reload_page(anchor)
{
    var url = window.location.href;
    if(url.indexOf('#') != -1)
        url = url.substring(0, url.indexOf('#'));
    
    if (anchor != null)
    {
        window.location = url + "#" + anchor.toString();
        window.location.reload(true);
    }
    else
    {
        window.location = url;
        window.location.reload(true);
    }
}

function go_to_page(url)
{
  window.location = url;
}

function set_page_design_source(page_src_id, page_dst_id)
{
    var url = "/az_pages/set_design_source/" + page_dst_id.toString() + "/" + page_src_id.toString();
    var op_id = operation_start('set_page_design_source');
    new Ajax.Request(url, {
      method: 'get',
      onSuccess: function(response) {
        update_page_box(page_dst_id);
        operation_finish(op_id, 'success');
      },
      onFailure: function(response) {
            //operation_finish(op_id, response.responseText);
            operation_finish(op_id, 'error');
        }
    });
}

function change_page_parent(page_id, old_parent_page_id, new_parent_page_id, link_id)
{
    var url = ""
    if (new_parent_page_id != null)
        url = "/az_pages/change_page_parent/" + page_id.toString() + "/" + link_id.toString() + "/" +  new_parent_page_id.toString();
    else
        url = "/az_pages/change_page_parent/" + page_id.toString();
    var op_id = operation_start('change_page_parent');
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
            //hide_structure_table_row(page_id, old_parent_page_id);
            copy_structure_table_row(page_id, new_parent_page_id);
            remove_structure_table_row(page_id, old_parent_page_id);
            draw_connectors();
            init_droplicious_menu();
            add_draggables_and_dropables();
            update_page_type_and_move_controls();
            operation_finish(op_id, 'success');
        },
        onFailure: function(response) {
            operation_finish(op_id, 'error');
        }
    });
}


function destroy_design(design_id, page_id)
{
    var url = "/az_designs/destroy2/" + design_id.toString();
    var op_id = operation_start('destroy_design');
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
            update_page_box(page_id);
            operation_finish(op_id, 'success');
        },
        onFailure: function(response) {
            operation_finish(op_id, 'error');
        }
    });
}

function add_page_parent(page_id, parent_page_id)
{
    if (page_id == parent_page_id)
        return;

    var url = ""
    if (parent_page_id != null)
        url = "/az_pages/add_page_parent/" + page_id.toString() + "/" + parent_page_id.toString();
    else
        url = "/az_pages/add_page_parent/" + page_id.toString();

    var op_id = operation_start('add_page_parent');
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
            copy_structure_table_row(page_id, parent_page_id);
            draw_connectors();
            init_droplicious_menu();
            add_draggables_and_dropables();
            update_page_type_and_move_controls();
            operation_finish(op_id, 'success');
        },
        onFailure: function(response) {
            operation_finish(op_id, 'error');
        }
    });
    
}

function attach_component_page_to_page(page_id, component_page_id)
{
    var url = "/az_pages/attach_component_page/" + page_id.toString() + "/" + component_page_id.toString();
    var op_id = operation_start('attach_component_page');
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
              add_sub_tree(component_page_id, page_id);
              update_page_box(page_id);
              operation_finish(op_id, 'success');
          },
        onFailure: function(response) {
              operation_finish(op_id, 'error');
          }
      });
}

function add_component_to_project(project_id, component_id)
{
    /*
    update_component_list(#{project.id})
    */
    var url = "/az_projects/add_component/" + project_id.toString() + "/" + component_id.toString();
    var op_id = operation_start('add_component_to_project');
    Windows.closeAll();
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
              update_component_list(project_id);
              operation_finish(op_id, 'success');
          },
        onFailure: function(response) {
              operation_finish(op_id, 'error');
          }
      });
}

function remove_component_page_from_page(page_id, component_page_id)
{
    var op_id = operation_start('remove_component_page');
    var url = "/az_pages/remove_component_page/" + page_id.toString() + "/" + component_page_id.toString();
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
            update_page_box(page_id);
            add_sub_tree2(page_id);
            operation_finish(op_id, 'success');
        },
        onFailure: function(response) {
             operation_finish(op_id, 'error');
        }
    });
}

function add_data_type_to_page(page_id, data_type_id)
{
    var url = "/az_pages/add_data_type/" + page_id.toString() + "/" + data_type_id.toString();
    var op_id = operation_start('add_data_type_to_page');
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
          update_page_box(page_id);
          operation_finish(op_id, 'success');
        },
        onFailure: function(response) {
            operation_finish(op_id, 'error');
        }
  });
}

function remove_data_type_from_page(page_id, data_type_id)
{
    var url = "/az_pages/remove_data_type/" + page_id.toString() + "/" + data_type_id.toString();
    var op_id = operation_start('remove_data_type_from_page');
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
          update_page_box(page_id);
          operation_finish(op_id, 'success');
        },
        onFailure: function(response) {
            operation_finish(op_id, 'error');
        }
    });
}


/*function update_page_type(type_id, dropped)
{
    var form = $$('#' + dropped.id + " .edit_az_page")[0];
    var inputs = Form.getInputs(form, 'hidden');
    for (i = 0; i < inputs.size(); i++)
    {
      if (inputs[i].className == 'ids_input')
      {
        inputs[i].setValue($("id-" + type_id).innerHTML);
        form.onsubmit();
      }
    }
}*/

/*function show_hide_sub_tree(node_path, this_element)
{
    var sub_tree_element = $("node-" + node_path + "-subtree");
    var hide_show_image_holder = this_element;
    var page_box_holder_element = $("page_box_holder_" + node_path);
    var page_menu_element = $("page-menu-" + node_path);
    var page_menu_c_element = $("page-menu-c-" + node_path);

    //alert(page_menu_element);
    //var page_info_element = $("page-info-" + page_id.toString());
    var page_left_icons_element = $("node-" + node_path + "-left-icons");

    if (sub_tree_element.visible())
    {
      sub_tree_element.hide();
      if(page_menu_element)
        page_menu_element.hide();
      page_menu_c_element.show();
      page_box_holder_element.hide();
      page_left_icons_element.hide();
      hide_show_image_holder.innerHTML = '<img alt="Expand fold" src="/images/expand_fold.png" alt="Развернуть поддерево" title="Развернуть поддерево" />'
      new Ajax.Request('/az_pages/collapse_node/' + node_path, { onSuccess: function(response){}, method: 'get' });
    }
    else
    {
      sub_tree_element.show();
      if(page_menu_element)
        page_menu_element.show();
      page_menu_c_element.hide();
      page_box_holder_element.show();
      page_left_icons_element.show();
      hide_show_image_holder.innerHTML = '<img alt="Collapse fold" src="/images/collapse_fold.png" alt="Свернуть поддерево" title="Свернуть поддерево"/>'
      new Ajax.Request('/az_pages/expand_node/' + node_path, { onSuccess: function(response){}, method: 'get' });
    }
    draw_connectors();
}*/

/*function get_page_id_and_link_id(element)
{
    var page_re = /^page-([0-9]*)$/;
    var link_re = /^link-([0-9]*)$/;
    var tr = element.up('tr.structure-row');
    var page_id = null;
    var link_id = null;
    if(tr != undefined)
    {
        $w(tr.className).each(function(cls){
            if (cls.match(page_re)){
                page_id = cls.substr('page-'.length, cls.length);
            }
            if (cls.match(link_re)){
                link_id = cls.substr('link-'.length, cls.length);
            }
        });
    }
    page_id = parseInt(page_id);
    link_id = parseInt(link_id);
    return [page_id, link_id];
}*/


function get_page_row(element)
{
    return element.up('tr.structure-row');
}

/*function get_head_page_row(element)
{
    var head_row;
    var head_rows = [];
    head_row = element.up('tr.structure-row');
    while(head_row != undefined)
    {
        head_rows.push(head_row);
        head_row = head_row.up('tr.structure-row');
    }
    if (head_rows.length < 2)
        return undefined;
    return head_rows[head_rows.length - 2];
}*/

function get_all_page_rows(page_id)
{
    return $$("tr.page-" + page_id.toString());
}

function get_page_rows(page_id, parent_page_id)
{
    var page_rows = $$("tr.page-" + page_id.toString());
    var rows = [];
    for (i = 0; i < page_rows.length; i++)
    {
        if (get_page_id(page_rows[i]) == parent_page_id)
            rows.push(page_rows[i]);
    }
    return rows;
}

function get_page_id(element)
{
    return get_page_id_or_link_id(element, 'page');
}

function get_page_link_id(element)
{
    return get_page_id_or_link_id(element, 'link');
}

function get_page_id_or_link_id(element, item)
{
    var class_str = "";
    if (item == 'page')
        class_str = "page-";
    else if (item == 'link')
        class_str = "link-";
    else
        return -1;

    var regexp = new RegExp('^' + class_str + '([0-9]*)$');
    var tr = get_page_row(element);
    var id = null;
    if(tr != undefined)
    {
        $w(tr.className).each(function(cls){
            if (cls.match(regexp)){
                id = cls.substr(class_str.length, cls.length);
                id = parseInt(id);
            }
        });
    }
    return id;
}

function get_data_type_id(element)
{
    var regexp = /^data-type-([0-9]*)$/;
    var id = null;
    $w(element.className).each(function(cls){
        if (cls.match(regexp)){
            id = cls.substr('data-type-'.length, cls.length);
            id = parseInt(id);
        }
    });
    return id;
}

function get_component_head_id(element)
{
    var regexp = /^component-head-([0-9]*)$/;
    var id = null;
    $w(element.className).each(function(cls){
        if (cls.match(regexp)){
            id = cls.substr('component-head-'.length, cls.length);
            id = parseInt(id);
        }
    });
    return id;
}

function get_parent_page_id(element)
{
    var tr = get_page_row(element);
    if (tr == undefined)
        return null;
    return get_page_id(tr.up());
}

function get_path(element)
{
    var re = /^page-([0-9]*)$/;
    var tr = get_page_row(element);
    var page_id;
    var path = '';

    while(tr != undefined){
        page_id = null;
        $w(tr.className).each(function(cls){
            if (cls.match(re)){
                page_id = cls.substr('page-'.length, cls.length);

                if (path == '')
                    path = page_id;
                else
                    path = page_id + '-' + path;
            }
        });
        if (page_id == null){
            path = null;
            break;
        }
        tr = get_page_row(tr);//tr.up('tr.structure-row');
    }
    return path;
}

function hide_sub_tree(element)
{
    show_hide_sub_tree(element, 'hide');
}

function show_sub_tree(element)
{
    show_hide_sub_tree(element, 'show');
}
function show_hide_sub_tree(element, hide_show)
{
    var tr = get_page_row(element);//element.up('tr.structure-row');
    var path = 'root-' + get_path(element);
    var j;

    var show_hide_element_classes = ['.page-left-icons',
                                     '.page_box_holder',
                                     '.sub-tree',
                                     '.tasks-info',
                                     '.collapse-icon',
                                     '.expand-icon',
                                     '.page-name-c',
                                     '.page-name-m'];
    
    for(j = 0; j < show_hide_element_classes.length; j++){
        var cls = show_hide_element_classes[j];
        var hide_element = tr.down(cls);
        if (hide_element != undefined){
          hide_element.toggle();
        }
    }

    draw_connectors();
    var collapse_expand = '';
    if (hide_show == 'hide')
      collapse_expand = 'collapse_node';
    else
      collapse_expand = 'expand_node';

    new Ajax.Request('/az_pages/' + collapse_expand + '/' + path, { onSuccess: function(response){}, method: 'get' });
}

function destroy_draggables(draggables)
{
    $w(draggables).each(function(draggable){
            draggable.destroy();
        });
}

function destroy_droppables(droppables)
{
    $w(droppables).each(function(droppable){
            Droppables.remove(droppable);
       });
}

function add_draggables_and_dropables()
{
    var element;
    var elements;
    var i, j;
    destroy_droppables(window.page_droppables);
    destroy_draggables(window.draggables);
    window.page_droppables = [];
    window.draggables = [];


    var draggable_classes = ['.page-anchors',
                             '.page-anchor',
                             '.draggable-design-source',
                             '.draggable-data-type',
                             '.component-head-anchor'];

    for(j = 0; j < draggable_classes.length; j++)
    {
        elements = $$(draggable_classes[j]);
        for(i = 0; i < elements.length; i++)
        {
            element = elements[i];
            add_draggable(element, window.draggables);
        }
    }
    

    var page_elements = $$('.page-box');
    for(i = 0; i < page_elements.length; i++)
    {
        element = page_elements[i];
        add_dropable(element, window.page_droppables);
    }
}

function add_dropable(element, list)
{
    var accept_classes = ['page-anchors',
                          'page-anchor',
                          'draggable-design-source',
                          'draggable-data-type',
                          'component-head-anchor'];

    Droppables.add(element, {
      accept: accept_classes,
      hoverclass: 'page-image-hover-anchor',
      onDrop: function(dragged, dropped, event) {process_drop(dragged, dropped, event);}
    });
    list.push(element);
}

function add_draggable(element, list)
{
    var d = new Draggable(element, {
        revert: true,
        scroll: window,
        ghosting: true,
        onStart: function(){window.show_page_menu = false; },
        onEnd: function(){window.show_page_menu = true; }
    });
    list.push(d);
}

function process_drop(dragged, dropped, event)
{
    if(dragged.hasClassName('page-anchors'))
    {
        process_drop_anchors(dragged, dropped, event);
    }
    else if (dragged.hasClassName('page-anchor'))
    {
        process_drop_anchor(dragged, dropped, event);
    }
    else if (dragged.hasClassName('draggable-design-source'))
    {
        process_drop_design_source_anchor(dragged, dropped, event);
    }
    else if (dragged.hasClassName('draggable-data-type'))
    {
        process_drop_data_type_anchor(dragged, dropped, event);
    }
    else if (dragged.hasClassName('component-head-anchor'))
    {
        process_drop_componet_anchor(dragged, dropped, event);
    }
    else
    {
        alert('ku-ku!');
    }
}

function process_drop_componet_anchor(dragged, dropped, event)
{
    var page_id = get_page_id(dropped);
    var component_page_id = get_component_head_id(dragged);
    attach_component_page_to_page(page_id, component_page_id);
    //add_data_type_to_page(page_id, data_type_id);
}

function process_drop_data_type_anchor(dragged, dropped, event)
{
    var page_id = get_page_id(dropped);
    var data_type_id = get_data_type_id(dragged);
    add_data_type_to_page(page_id, data_type_id);
}

function process_drop_anchors(dragged, dropped, event)
{
    var dragged_page_id = get_page_id(dragged);
    var dropped_page_id = get_page_id(dropped);
    add_page_parent(dragged_page_id, dropped_page_id);
}

function process_drop_anchor(dragged, dropped, event)
{
    var page_id = get_page_id(dragged);
    var old_page_id = get_parent_page_id(dragged);
    var link_id = get_page_link_id(dragged);
    var new_page_id = get_page_id(dropped);
    change_page_parent(page_id, old_page_id, new_page_id, link_id);
}

function process_drop_design_source_anchor(dragged, dropped, event)
{
    var src_page_id = get_page_id(dragged);
    var dst_page_id = get_page_id(dropped);
    set_page_design_source(src_page_id, dst_page_id);
}

function add_draggable_design(element, page_id)
{
  if (element != null)
  {
    element.page_id = page_id;
    new Draggable(element, {
      revert: true,
      scroll: window,
      onEnd: function(){}
    });
  }
}

function show_hide_controls()
{
    var elements = $$(".page-left-icons");
    //elements = elements.concat($$(".page-menu"));


    elements = elements.concat($$(".floppy"));
    elements = elements.concat($$(".draggable-design-source"));
    elements = elements.concat($$(".root-page-menu"));
    elements = elements.concat($$(".page-folder"));
    elements = elements.concat($$(".complete"));
    elements = elements.concat($$(".remove-design-source-holder"));
    
    var element;

    var show_link = $("show-controls-link");
    var hide_link = $("hide-controls-link");

    if (show_link.visible())
        show_link.hide();
    else
        show_link.show();

    if (hide_link.visible())
        hide_link.hide();
    else
        hide_link.show();

    for (i = 0; i < elements.size(); i++)
    {
        element = elements[i];
        if (element.visible())
        {
          element.hide();
        }
        else
        {
          element.show();
        }
    }
    draw_connectors();
}

function show_dialog(url, width, height, method)
{
  width = typeof(width) != 'undefined' ? width : 150;
  height = typeof(height) != 'undefined' ? height : 150;
  method = typeof(method) != 'undefined' ? method : 'get';

  var op_id = operation_start('show_dialog');
  Windows.closeAll();
  contentWin = new Window({className: "azalo", maximizable: false, closable: true, resizable: false, hideEffect:Element.hide, showEffect:Element.show, width: width, height: height, destroyOnClose: true, right: 0 })
  contentWin.setAjaxContent(url,
                            {method: method,
                                 onComplete: function showWindow(responce){
                                      contentWin.showCenter();
                                      contentWin.updateWidth();
                                      contentWin.updateHeight();
                                      operation_finish(op_id, 'success');
                                 }
                            });
}

function show_dialog_with_static_text(text_with_html, width, height)
{
  
  width = typeof(width) != 'undefined' ? width : 150;
  height = typeof(height) != 'undefined' ? height : 150;
  Windows.closeAll();
  contentWin = new Window({className: "azalo", maximizable: false, closable: true, resizable: false, hideEffect:Element.hide, showEffect:Element.show, width: width, height: height, destroyOnClose: true, right: 0 })
  contentWin.setHTMLContent(text_with_html);
  contentWin.showCenter();
  contentWin.updateWidth();
  contentWin.updateHeight();
}

function show_new_sub_page_dialog(page_id)
{
    show_dialog("/az_pages/" + page_id.toString() + "/new_sub_page", 270, 100);
}

function show_new_collection_dialog(datatype_id)
{
    show_dialog("/az_collection_data_types/new/" + datatype_id.toString(), 400, 390);
}

function show_edit_collection_dialog(collection_id)
{
    show_dialog("/az_collection_data_types/edit/" + collection_id.toString(), 400, 390);
}

function show_new_page_dialog(project_id)
{
  show_dialog("/az_pages/new/" + project_id.toString(), 270, 100);
}

function show_edit_page_dialog(page_id)
{
  show_dialog("/az_pages/edit_page/" + page_id.toString(), 270, 100);
}

function show_operations_edit_dialog(typed_page_id)
{
  show_dialog("/az_typed_pages/operations_dialog/" + typed_page_id.toString(), 220, 130);
}

function show_struct_info_dialog(struct_id)
{
  show_dialog("/az_struct_data_types/info_tooltip/" + struct_id);
}
function show_download_designs_dialog(page_id)
{
  show_dialog("/az_pages/download_designs_dialog/" + page_id.toString(), 440, 90);
}

function show_designs_dialog(page_id)
{
  show_dialog("/az_pages/designs_tooltip/" + page_id.toString(), 260, 390);
}

function show_new_design_dialog(page_id)
{
  show_dialog("/az_designs/new_design/" + page_id.toString(), 400, 400);
}

function show_update_design_dialog(design_id)
{
  show_dialog("/az_designs/update_design/" + design_id.toString(), 400, 400);
}

function show_description_dialog(page_id)
{
  show_dialog("/az_pages/description_dialog/" + page_id.toString(), 600, 330);
}

function show_description_dialog_wo_title(page_id, page_box_to_update_id)
{
  show_dialog("/az_pages/description_wo_title_dialog/" + page_id.toString() + "/" + page_box_to_update_id.toString(), 600, 280);
}

function show_tr_description_dialog(page_id)
{
    show_dialog("/az_pages/tr_description_tooltip/" + page_id.toString(), 600, 330);
}

function show_tr_new_definition_dialog(owner_id, base_project_id)
{
    show_dialog("/az_definitions/tr_new_definition_dialog/" + owner_id.toString() + "/" + base_project_id.toString(), 600, 330);
}

function show_tr_new_common_dialog(common_controller, owner_id, base_project_id)
{
    show_dialog("/" + common_controller + "/tr_new_dialog/" + owner_id.toString() + "/" + base_project_id.toString(), 600, 330);
}

function show_tr_description_dialog_wo_title(page_id, page_to_update_id)
{
    show_dialog("/az_pages/tr_description_wo_title_tooltip/" + page_id.toString() + "/" + page_to_update_id.toString(), 600, 280);
}

function show_tr_page_position_dialog(page_id)
{
    show_dialog("/az_pages/tr_page_position_dialog/" + page_id.toString(), 280, 100);
}

function show_tr_page_status_dialog(page_id)
{
    show_dialog("/az_pages/tr_page_status_dialog/" + page_id.toString(), 280, 100);
}

function show_project_status_dialog(project_id)
{
    show_dialog("/az_projects/status_edit_dialog/" + project_id.toString(), 280, 100);
}

function show_project_access_dialog(project_id)
{
    show_dialog("/az_base_projects/access_edit_dialog/" + project_id.toString(), 280, 100);
}

function show_project_access_dialog_warning()
{
    show_text_dialog("Приватные проекты доступны в платных тарифах.")
}

function show_text_dialog(text)
{
    show_dialog_with_static_text("<h3>" + text + "</h3>", 280, 100);
}


function show_new_guest_link_dialog(project_id)
{
    show_dialog("/az_guest_links/new/" + project_id.toString(), 280, 100);
}

function show_edit_guest_link_dialog(guest_link_id)
{
    show_dialog("/az_guest_links/edit/" + guest_link_id.toString(), 280, 100);
}

function show_page_tasks_dialog(page_id)
{
  show_dialog("/az_pages/page_tasks_dialog/" + page_id.toString(), 480, 250);
}

function show_project_tasks_dialog(project_id)
{
  show_dialog("/az_projects/unassigned_tasks_dialog/" + project_id.toString(), 480, 250);
}

function show_unassigned_tasks_dialog(project_id)
{
  show_dialog("/az_projects/unassigned_tasks_dialog/" + project_id.toString(), 480, 250);
}

function show_new_page_tasks_dialog(page_id)
{
  show_dialog("/az_pages/new_tasks/" + page_id.toString(), 680, 300);
}

function show_new_project_task_dialog(project_id, task_id)
{
  show_dialog("/az_projects/new_task/" + project_id.toString() + "/" + task_id.toString(), 580, 450);
}

function show_new_project_tasks_dialog(project_id)
{
  show_dialog("/az_projects/new_tasks/" + project_id.toString(), 680, 300);
}

function show_new_page_task_dialog(page_id, task_id)
{
  show_dialog("/az_pages/new_task/" + page_id.toString() + "/" + task_id.toString(), 580, 450);
}

function show_select_task_types_dialog(project_id)
{
  show_dialog("/az_projects/task_types_select_dialog/" + project_id.toString(), 580, 300);
}

function show_selected_task_types_dialog(project_id)
{
  show_dialog("/az_projects/task_types_selected_dialog/" + project_id.toString(), 580, 300);
}

function show_new_variable_dialog(struct_id)
{
    show_dialog("/az_variables/show_new_variable_dialog/" + struct_id.toString(), 580, 380);
}

function show_edit_variable_dialog(variable_id)
{
  show_dialog("/az_variables/show_edit_variable_dialog/" + variable_id.toString(), 680, 400);
}

function show_participants_dialog(project_id)
{
  show_dialog("/az_projects/show_participants_dialog/" + project_id.toString(), 680, 300);
}

function show_components_dialog(project_id)
{
  show_dialog("/az_project_blocks/components_dialog/" + project_id.toString(), 400, 450);
}

function show_not_enough_money_dialog(item_id)
{
  show_dialog("/az_store_items/not_enough_money_dialog/" + item_id.toString(), 480, 180);
}

function show_select_company_dialog(item_id)
{
  show_dialog("/az_store_items/select_company_dialog/" + item_id.toString(), 480, 280);
}
function show_select_company_dialog2(item_type, item_id)
{
  show_dialog("/az_companies/select_company_dialog/0?item_id=" + item_id.toString(), 480, 280);
}



/*function show_create_design_dialog_result()
{
  show_dialog("/az_designs/create/", 400, 350);
}*/

window.update_image_in_designs_dialog_by_event = function(event)
{
    var diz_id = this.id.substring("diz-".length);
    update_image_in_designs_dialog_by_id(diz_id);
}

window.update_image_in_designs_dialog_by_id = function(diz_id)
{
    $("design_dialog_design_description").innerHTML = $("hidden-diz-description-" + diz_id).innerHTML;
    $("design_dialog_medium_image").innerHTML = $("hidden-diz-image-" + diz_id).innerHTML;
    $("update-remove-design-link-container").innerHTML = $("hidden-diz-update-link-" + diz_id).innerHTML;
}

function show_tr_text_edit_dialog(url)
{
  show_dialog(url, 580, 300);
}

function show_tr_string_edit_dialog(url)
{
  show_dialog(url, 580, 300);
}

function show_tr_status_dialog(url)
{
  show_dialog(url, 280, 100);
}

function hide_show_project_panel(project_id)
{
    Effect.toggle("project-panel-content", 'appear', {duration: 0, afterFinish:function() {draw_connectors();}});
    Effect.toggle("project-panel-hidden-content", 'appear', {duration: 0, afterFinish:function() {draw_connectors();}});

    Effect.toggle("project-panel-collapse", 'appear', {duration: 0, afterFinish:function() {draw_connectors();}});
    Effect.toggle("project-panel-expand", 'appear', {duration: 0, afterFinish:function() {draw_connectors();}});

    if ($("project-panel-content").visible())
    {
      new Ajax.Request('/az_projects/collapse_panel/' + project_id.toString(), { onSuccess: function(response){} });
    }
    else
    {
      new Ajax.Request('/az_projects/expand_panel/' + project_id.toString(), { onSuccess: function(response){} });
    }
}

function update_variables_list_in_structure(struct_id)
{
    var op_id = operation_start('update_variables_list');
    new Ajax.Updater('variables-struct-id-' + struct_id.toString() , '/az_struct_data_types/variables_list/' + struct_id.toString(),
        {
            method: 'get',
            evalScripts: true,
            onSuccess: function(response) {
                operation_finish(op_id, 'success');
            },
            onFailure: function(response) {
                operation_finish(op_id, 'error');
            }
        })
}

function update_commons_in_tr(commons_name)
{
    var op_id = operation_start('update_commons_in_tr');
    new Ajax.Updater(commons_name,
        '/az_base_projects/tr_commons_content/' + window.project_id.toString() + "/" + commons_name,
        {
            method: 'get',
            evalScripts: true,
            onSuccess: function(response) {
                operation_finish(op_id, 'success');
            },
            onFailure: function(response) {
                operation_finish(op_id, 'error');
            }
        })
}

function update_definitions_in_tr()
{
    var op_id = operation_start('update_definitions_in_tr');
    new Ajax.Updater("definitions",
        '/az_base_projects/tr_definitions_content/' + window.project_id.toString(),
        {   method: 'get',
            evalScripts: true,
            onSuccess: function(response) {
                operation_finish(op_id, 'success');
            },
            onFailure: function(response) {
                operation_finish(op_id, 'error');
            }
        })
}

/*function update_public_pages_in_tr(project_id, project_class_name)
{
  new Ajax.Updater("public-pages", '/'+ project_class_name + '/tr_public_pages_content/' + project_id.toString(), {method: 'get', evalScripts: true})
}

function update_admin_pages_in_tr(project_id, project_class_name)
{
  new Ajax.Updater("admin-pages", '/'+ project_class_name + '/tr_admin_pages_content/' + project_id.toString(), {method: 'get', evalScripts: true})
}*/

function update_structs_validatots_in_tr()
{
    var op_id = operation_start('update_structs_validatots_in_tr');
    new Ajax.Updater("structs",
        '/'+ window.project_type + '/tr_structs_validators_content/' + window.project_id.toString(),
        {
            method: 'get',
            evalScripts: true,
            onSuccess: function(response) {
                operation_finish(op_id, 'success');
            },
            onFailure: function(response) {
                operation_finish(op_id, 'error');
            }
        })
}


function show_hide_tr_pages(page_type, project_id)
{
    var page_holders, img1, img2, url_collapse, url_expand;
    var admin_public;

    admin_public = page_type == "admin" ? "admin" : "public";

    page_holders = $$(".tr-" + admin_public + "-page-description");
    //alert(page_holders);
    img1 = $("tr-collapse-" + admin_public + "-pages");
    img2 = $("tr-expand-" + admin_public + "-pages");
    url_collapse = "/az_projects/tr_collapse_" + admin_public + "_pages/" + project_id.toString();
    url_expand = "/az_projects/tr_expand_" + admin_public + "_pages/" + project_id.toString();

    if (img1 && img2)
    {
      page_holders.push(img1);
      page_holders.push(img2);
    }
    var visible;
    
    for (i = 0; i < page_holders.size(); i++)
    {
      if (page_holders[i].visible())
      {
        page_holders[i].hide();
        visible = false;
      }
      else
      {
        page_holders[i].show();
        visible = true;
      }
    }

    if (visible)
      new Ajax.Request(url_collapse, { onSuccess: function(response){}, method: 'get' });
    else
      new Ajax.Request(url_expand, { onSuccess: function(response){}, method: 'get' });
}

function move_page_up(element)
{
    move_page_up_down(element, 'up');
}

function move_page_down(element)
{
    move_page_up_down(element, 'down');
}

function move_page_up_down(element, direction)
{
    var page_id = get_page_id(element);
    var parent_page_id = get_parent_page_id(element);
    var page_rows = get_page_rows(page_id, parent_page_id);
    for(i = 0; i < page_rows.length; i++)
    {
        var tr = page_rows[i];
        var other;
        if (direction == 'up')
        {
            other = tr.previous();
        }
        else
        {
            other = tr.next();
        }
        if (other != undefined){
            swap(tr, other);

        }
    }
    draw_connectors();
    
    var url = "/az_pages/move_" + direction + "/" + page_id.toString() + "/" + parent_page_id.toString();

    var op_id = operation_start('move_page');
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
            operation_finish(op_id, 'success');
        },
        onFailure: function(response) {
            operation_finish(op_id, 'error');
        }
    });
}

function swap(element, other) {
    element = $(element);
    other = $(other);
    if (element !== other) {
        var stub = document.createElement('div');
        other = Element.replace(other, stub);
        element = Element.replace(element, other);
        stub = Element.replace(stub, element);
        stub = null;
    }
    return element;
}

function hide_structure_table_row(page_id, parent_page_id)
{
    var i;
    var page_elements_to_remove = get_page_rows(page_id, parent_page_id);
    for(i = 0; i < page_elements_to_remove.length; i++){
        var element_to_remove = page_elements_to_remove[i];
        //element_to_remove.hide();
        $(element_to_remove).setStyle({display: 'block', overflow: 'hidden'});
        element_to_remove.morph('height: 0px;', { duration: 3.0 });
        //Effect.SlideUp(element_to_remove, { duration: 3.0 });
    }
}

function remove_structure_table_row(page_id, parent_page_id)
{
    var i;
    var page_elements_to_remove = get_page_rows(page_id, parent_page_id);
    for(i = 0; i < page_elements_to_remove.length; i++){
        var element_to_remove = page_elements_to_remove[i];
        element_to_remove.fade({ duration: 0.5, afterFinish: function(){element_to_remove.remove(); draw_connectors();} });
    }
}

function copy_structure_table_row(page_id, parent_page_id)
{
    reset_draggables_style(page_id);
    var i;
    var rows = $$('tr.page-' + page_id.toString());
    if (rows.length == 0)
        return;

    var row = rows[0];
    var tbodies = get_page_sub_tree_tbody(parent_page_id);
    for(i = 0; i < tbodies.length; i++)
    {
        var tbody = tbodies[i];
        tbody.insert(row.clone(true));
    }
}

function get_page_sub_tree_tbody(page_id)
{
    var i;
    var tbodies = [];
    var rows = $$('tr.page-' + page_id.toString());
    var row;

    for(i = 0; i < rows.length; i++)
    {
        row = rows[i];
        var sub_tree = row.down('.sub-tree');
        if (sub_tree != undefined)
        {
            var table = sub_tree.down('table.structure-table');
            if (table != undefined)
            {
                var tbody = table.down('tbody');
                if (tbody != undefined)
                {
                    tbodies.push(tbody);
                }
            }
        }
    }
    return tbodies;
}

function update_page_name_and_type(page_id, page_name, page_type, embedded_type)
{
    var i, k;
    var rows = get_all_page_rows(page_id);

    var page_name_element;
    for(i = 0; i < rows.length; i++)
    {
        page_name_element = rows[i].down('.page-name-c');
        if(page_name_element != undefined)
            page_name_element.innerHTML = page_name;


        var page_name_m_element = rows[i].down('.page-name-m');
        if(page_name_m_element != undefined){
            page_name_element = page_name_m_element.down('.page-name');
            if(page_name_element != undefined)
                page_name_element.innerHTML = page_name;
        }
        
    }
    var head_rows;
    var old_class, new_class;

    if(page_type == 'admin')
    {
        old_class = 'user';
        new_class = 'admin';
    }
    else
    {
        old_class = 'admin';
        new_class = 'user';
    }

    head_rows = $$("tr.structure-row.page-" + page_id.toString() + "." + old_class);
    for(k = 0; k < head_rows.length; k++)
    {
        head_rows[k].removeClassName(old_class);
        head_rows[k].addClassName(new_class);

        if(embedded_type == 'embedded')
            head_rows[k].addClassName('embedded');
        else
            head_rows[k].removeClassName('embedded');
    }
    head_rows = $$("tr.structure-row.page-" + page_id.toString());
    for(k = 0; k < head_rows.length; k++)
    {
        var page_box = head_rows[k].down('.page-box');
        if (page_box == undefined)
            continue;

        if(embedded_type == 'embedded')
            page_box.addClassName('embedded');
        else
            page_box.removeClassName('embedded');
    }



    Windows.closeAll();
}

function init_droplicious_menu()
{
    window.dropmenu = null;
    window.dropmenu = new dropliciousMenu();
}

function remove_page(element)
{
    var page_id = get_page_id(element);
    var parent_page_id = get_parent_page_id(element);

    remove_structure_table_row(page_id, parent_page_id);

    var url = "/az_pages/destroy_lnk/" + page_id.toString() + "/" + parent_page_id.toString();
    var op_id = operation_start('remove_page');
    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(transport) {
            update_page_type_and_move_controls();
            operation_finish(op_id, 'success');
            //remove_structure_table_row(page_id, parent_page_id);
        },
        onFailure: function(transport) {
            operation_finish(op_id, 'error');
        }
    });
}

function add_sub_tree(page_id, parent_page_id)
{
    var show_mode = window.show_mode;
    var project_id = window.project_id;
    project_type = window.project_type;
    var url = "/" + project_type + "/show_sub_tree/" + project_id.toString() + "/" + parent_page_id.toString() + "/" + page_id.toString() + "/" + show_mode;
    var op_id = operation_start('add_sub_tree');

    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
            Windows.closeAll();
            var tbodies = get_page_sub_tree_tbody(parent_page_id);
            for(var i = 0; i < tbodies.length; i++)
            {
                tbodies[i].insert(response.responseText);
            }
            draw_connectors();
            init_droplicious_menu();
            add_draggables_and_dropables();
            update_page_type_and_move_controls();
            operation_finish(op_id, 'success');
        },
        onFailure: function(response) {
            operation_finish(op_id, 'error');
        }
    });
}

function add_sub_tree2(page_id)
{
    var show_mode = window.show_mode;
    var project_id = window.project_id;
    project_type = window.project_type;
    var url = "/" + project_type + "/show_sub_tree2/" + project_id.toString() + "/" + page_id.toString() + "/" + show_mode;
    //var url = "/" + project_type + "/show_sub_tree2/" + project_id.toString() + "/52397/" + show_mode;
    var op_id = operation_start('add_sub_tree2');

    new Ajax.Request(url, {
        method: 'get',
        onSuccess: function(response) {
            update_page_box(page_id);
            var tbodies = get_page_sub_tree_tbody(page_id);
            for(var i = 0; i < tbodies.length; i++)
            {
                tbodies[i].innerHTML = response.responseText;
            }
            draw_connectors();
            init_droplicious_menu();
            add_draggables_and_dropables();
            update_page_type_and_move_controls();
            operation_finish(op_id, 'success');
        },
        onFailure: function(response) {
            operation_finish(op_id, 'error');
        }
    });
}

function update_page_type_and_move_controls()
{
    var main_table = $('structure-table')
    var root_element = main_table.down('.sub-tree');
    update_move_controls(root_element)
}

function update_move_controls(sub_tree_element)
{
    var row;
    var rows;
    var e, i;

    rows = $$('tr.structure-row');
    for(i = 0; i < rows.length; i++)
    {
        row = rows[i];
        e = row.down('.page-up-down');
        if(e != undefined)
            e.show();
    }

    rows = $$('tr.structure-row:only-child');
    for(i = 0; i < rows.length; i++)
    {
        row = rows[i];
        e = row.down('.page-up-down');
        if(e != undefined)
            e.hide();
    }
}

