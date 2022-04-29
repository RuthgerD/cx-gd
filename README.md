## A godot 4 declarative and reactive scene management library
__This is made for personal projects, don't expect anything.__

This project abuses the new lambda feature of gdscript to declaritively manage the scene tree via concepts you might expect from modern UI libraries:
* Reactive values
* Mapping values to children
* Selective scene rebuilding

and there is __0__ (_rounded down_) magic trickery going on to achieve this and extends beyond just UI applications.

"Simple" example introducing key concepts:
```python
class_name Demo
extends Control

# simple named widget constructor, note how it returns a function
var button_widget = func(index: Tracked, text: String): return func(c: Ctx):
    # create a Button node
    c.inherits(Widgets.button())
    # concatinate tracked index with static text value
    var concat = Cx.map(index, func(i): return str(i) + ". " + text)
    # set the text property of the Button with the reactive label
    c.with("text", concat)
    # hide the node when text is empty by mapping the text value
    c.with("visible", !text.is_empty())

func _ready():
    # considered "inside node" thus we need to create or get a context
    var c: Ctx = Cx.get_or_init(self) 
    # create a reactive array of values
    var labels := Cx.array(["hello", "world", "", "last"])
    # add a child, this can be a plain Node deriving type,
    # or more interestingly a function taking Ctx
    c.child(func(c: Ctx):
        # "inherit" from container, this will be the node in the scene tree
        c.inherits(VBoxContainer)
        # for each label instance a label widget
        # note how `v` is NOT tracked but `i` is
        c.child_opt(Cx.map_children(labels, func(i, v): return func(c: Ctx):
            # inherit external widget
            c.inherits(button_widget.call(i, v))
            # add a click handler to remove clickee,
            # this will automatically remove this node from the tree as we "declared" it to be so
            c.on("pressed", func(): labels.remove_at(i.value()))
        ))
    )

```

