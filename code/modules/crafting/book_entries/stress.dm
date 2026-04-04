/datum/book_entry/rotation_stress
	name = "Rotational Stress"


/datum/book_entry/rotation_stress/inner_book_html(mob/user)
	return {"
		<div>
		<h2>What is a Rotational Stress</h2>
		Rotational stress is a visualization of the used torque of all connected rotational devices.<br>
		</div>
		<br>

		<div>
		<h2> How to generate Stress </h2>
		The most common way of this is the waterwheel, it generates a moderate amount of stress at low speed.<br>
		</div>
		<br>

		<div>
		<h2> How to increase Rotational Speed </h2>
		You can amplify speed of machines through the use of gear ratios. Going from a large cog to a small cog will double the speed up to a maximum of 256 RPM. <br>
		Increasing the speed also amplifies the cost of machines, for instance going from 4 to 8 rpm on something that uses 5% of your stress will double it to 10%. <br>
		Going from a Small Cog to a Large Cog will halve the speed to a minimum of 1 RPM.<br>
		If two opposing directions clash one side will break at the connecting point. So you need to make sure if you are connecting waterwheels they connect with the same direction.
		</div>
		<br>

		<div>
		<h2> How to find out how close you are to overstressing </h2>
		If you overstress the network everything comes to a halt. <br>
		To avoid this you want to get some engineers goggles,<br>
		this lets you see the overall stress usage and RPM of the network at any given structure.
		</div>
	"}
