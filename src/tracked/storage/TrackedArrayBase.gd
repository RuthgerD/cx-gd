class_name TrackedArrayBase extends TrackedContainer

var _arr = []

func value(): return self._arr
func size(): return self._arr.size()
func keys(): return self.size()

func change(v):
    assert(v is Array)
    var deleted_keys = self.keys()
    self._arr = v
    _emit_change(SET, deleted_keys)

func _change_at(at, v):
    assert(at < self.size(), "out of bounds")
    self._arr[at] = v
    _emit_change(MODIFIED, at)

func _insert_at(at, v):
    assert(at <= self.size(), "out of bounds")
    self._arr.insert(at, v)

    var size = self.size() -1
    for j in size - at:
        var fromto = [size - j + at - 1, size - j + at]
        _emit_change(MOVED, fromto)

    _emit_change(INSERTED, at)

func _remove_at(at):
    assert(at >= 0 && at <= self.size(), "out of bounds")
    
    self._arr.remove_at(at)
    _emit_change(REMOVED, at)

    for j in self.size() - at:
        var fromto = [j + at + 1, j + at]
        _emit_change(MOVED, fromto)

func append_array(arr: Array):
    for v in arr:
        self.push(v)

func clear():
    self.change([])

func _get_class(): return "TrackedArrayBase"
