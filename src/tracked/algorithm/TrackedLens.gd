class_name TrackedLens extends Tracked

var _tracked: Tracked
var _key: String

func value():
    var val = self._tracked.value()
    if val == null: return null
    return val[self._key]

func change(v):
    _tracked.mutate(func(z):
        print(z)
        print(v)
        print(_key)
        print(_tracked)
        z[_key] = v
        return z
    )

func _init(tracked: Tracked, key: String):
    self._tracked = tracked
    self._key = key
    
    tracked.changed.connect(self._update)

func _update(w,h):
    emit_set()
    
func _get_class(): return "TrackedLens"
