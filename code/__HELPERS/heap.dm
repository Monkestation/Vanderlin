/datum/Heap
	var/list/L
	var/cmp

/datum/Heap/New(compare)
	L = new()
	cmp = compare

/datum/Heap/proc/IsEmpty()
	return !L.len

/datum/Heap/proc/Insert(atom/A)
	L[++L.len] = A
	Swim(length(L))

/datum/Heap/proc/Pop()
	if(!L.len)
		return null
	. = L[1]
	L[1] = L[L.len]
	L.Cut(L.len)
	if(L.len)
		Sink(1)

/datum/Heap/proc/Swim(index)
	while(index > 1)
		var/parent = round(index * 0.5)
		if(call(cmp)(L[index], L[parent]) <= 0)
			break
		L.Swap(index, parent)
		index = parent

/datum/Heap/proc/Sink(index)
	var/length = L.len
	var/max_iterations = length

	while(max_iterations > 0)
		var/left_child = index * 2
		var/right_child = index * 2 + 1
		var/largest = index

		if(left_child <= length && call(cmp)(L[left_child], L[largest]) > 0)
			largest = left_child

		if(right_child <= length && call(cmp)(L[right_child], L[largest]) > 0)
			largest = right_child

		if(largest == index)
			break

		L.Swap(index, largest)
		index = largest
		max_iterations--

	if(max_iterations <= 0)
		stack_trace("Potential infinite loop in Heap Sink method")

/datum/Heap/proc/ReSort(atom/A)
	var/index = L.Find(A)
	if(index)
		Swim(index)
		Sink(index)

/datum/Heap/proc/List()
	return L.Copy()
