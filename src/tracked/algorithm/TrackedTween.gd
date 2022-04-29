class_name TrackedTween extends TrackedValue

var _tracked: Tracked
var _tween: Tween

var _speed: float
var _trans: Tween.TransitionType
var _target

func _init(ob: Tracked, speed: float, trans: Tween.TransitionType = 0) -> void:
    self._tracked = ob
    self._speed = speed
    self._trans = trans
    self._value = ob.value()
    
    ob.changed.connect(self._update)
    
    _update(0,0)

func _update(w,h):
    var completed := 1.0
    if self.value() == self._tracked.value() || self._tracked.value() == _target:
        return
    elif is_instance_valid(_tween) && _tween.is_valid():
        var time_left = _tween.get_total_elapsed_time()
        completed = (time_left / self._speed)
        _tween.stop()
        _tween = null
    
    print("Finished %0.2f" % completed)
    
    var tree := Engine.get_main_loop() as SceneTree
    assert(tree)
    
    var new_target = self._tracked.value()

    _tween = tree.create_tween()
    _tween.tween_property(self, "_value", new_target, self._speed)
    _target = new_target
    _tween.play()


func get_class(): return "TrackedTween"
