/datum/book_entry/cavity_access
	name = "Accessing Body Cavities"

/datum/book_entry/cavity_access/inner_book_html(mob/user)
	return {"
		<div>
		<h2>Accessing Body Cavities</h2>
		To access the organs within a body cavity, the area must first be surgically opened.
		After which you need to be on TOUCH Intent and drag them onto you.
		Remove any clothing covering the target area before beginning.
		</div>
		<br>
		<div>
		<h3>Standard Cavities</h3>
		For unencased areas such as the abdomen or limbs, you will need to:
		<ol>
			<li>Make an <b>incision</b> using a scalpel or other sharp instrument.</li>
			<li>Use a <b>retractor</b> to hold the wound open.</li>
		</ol>
		The cavity is now accessible. Organs within can be severed, healed, or removed.
		</div>
		<br>
		<div>
		<h3>Encased Cavities</h3>
		For encased areas such as the skull or ribcage, additional steps are required:
		<ol>
			<li>Make an <b>incision</b> using a scalpel or other sharp instrument.</li>
			<li>Use a <b>retractor</b> to hold the wound open.</li>
		</ol>
		</div>
	"}

/datum/book_entry/organ_surgery
	name = "Operating on Organs"

/datum/book_entry/organ_surgery/inner_book_html(mob/user)
	return {"
		<div>
		<h2>Operating on Organs</h2>
		Once a cavity is open, you may interact directly with the organs inside.
		All organ operations require the cavity to be properly accessed first - see <i>Accessing Body Cavities</i>.
		</div>
		<br>
		<div>
		<h3>Severing an Organ</h3>
		Use any <b>sharp instrument or scalpel</b> on the organ inside the open cavity.
		The operation takes approximately <b>6 seconds</b>, the patient must remain still throughout.
		<br><br>
		Once severed, the organ will remain in the cavity and can be removed by hand.
		A severed organ still inside its owner will not function until reattached.
		</div>
		<br>
		<div>
		<h3>Reattaching a Severed Organ</h3>
		Use the appropriate <b>attaching material</b> on the severed organ while it remains inside the patient.
		This consumes <b>2 units</b> of the material and takes approximately <b>3 seconds</b>.
		<br><br>
		Each organ has its own attaching requirements - consult the relevant organ page for specifics.
		</div>
		<br>
		<div>
		<h3>Healing a Damaged Organ</h3>
		Damaged organs can be treated directly using the appropriate <b>healing items or tools</b>.
		This consumes <b>2 units</b> of material where applicable and takes approximately <b>5 seconds</b>.
		Each application restores a significant portion of the organ's health.
		<br><br>
		<h3>Burning Rot</h3>
		Rotten organs can be treated directly using a <b>cautery</b>.
		Each application will burn away all the rot on the organ.
		<br><br>
		Organs that are fully destroyed or necrotic cannot be healed by this method.
		Consult the organ's page to see what items and tools it accepts.
		</div>
	"}

/datum/book_entry/lobotomy
	name = "Lobotomy"

/datum/book_entry/lobotomy/inner_book_html(mob/user)
	return {"
		<div>
		<h2>Lobotomy</h2>
		A lobotomy is a crude but effective procedure that severs connections within the brain,
		removing certain traits and mutations at the cost of the patient's cognitive integrity.
		</div>
		<br>
		<div>
		<h3>Procedure</h3>
		<ol>
			<li>Access the <b>skull cavity</b>; incise, retract, then fracture the skull.</li>
			<li>Use a <b>hemostat</b> directly on the <b>brain</b>.</li>
		</ol>
		The procedure is immediate once the tool is applied.
		</div>
		<br>
		<div>
		<h3>Effects</h3>
		A lobotomy will remove certain genetic mutations and traits from the patient.
		The procedure is <b>irreversible</b> without further medical intervention.
		<br><br>
		<b>Warning:</b> This is a destructive procedure. Consider carefully before performing it on an unwilling or unconscious patient.
		</div>
	"}
/datum/book_entry/pestran_chimeric
	name = "Chimeric Organ Techniques"
/datum/book_entry/pestran_chimeric/inner_book_html(mob/user)
	return {"
		<div>
		<h2>Chimeric Organ Techniques</h2>
		The Pestran tradition holds that the body is not a closed vessel but a living instrument,
		one that may be opened, reshaped, and made to accommodate that which does not naturally belong within it.
		Chimeric surgery is the practical expression of this belief: the alteration of a living organ so that
		foreign humors may be grafted directly into its structure and made to function as part of the whole.
		<br><br>
		All chimeric procedures are performed directly on the heart while it remains inside the patient.
		The chest cavity must be open before any of the following steps can be taken.
		</div>
		<br>
		<div>
		<h3>Chimeric Transformation</h3>
		Before any humor can be accepted, the heart must first be transformed to receive foreign tissue.
		Apply a <b>hemostat</b> to the heart of a patient whose organ has not yet been transformed.
		<br><br>
		The procedure takes approximately <b>10 seconds</b> and must not be interrupted.
		Upon completion the organ will be capable of receiving humors, and the patient's body
		will begin storing blood essence as a substrate for their function.
		</div>
		<br>
		<div>
		<h3>Placing Humors</h3>
		Once the heart has been transformed, humors may be placed against it by attacking the heart
		directly with the <b>humor item</b>. The humor will adhere to the organ surface and wait to be stitched.
		Any number of humors may be placed before stitching.
		<br><br>
		Humors cannot be placed on a failed chimeric organ. Repair it first.
		</div>
		<br>
		<div>
		<h3>Stitching</h3>
		Once all desired humors have been placed, sew it in place using a <b>needle</b> to the heart to stitch them all in at once.
		The time taken scales with the number of humors being stitched.
		Each successfully stitched humor increases the blood essence requirement of the organ.
		The operator will be shown the current requirements and stored amounts after stitching completes.
		<br><br>
		Humors that are rejected during stitching are not attached.
		</div>
		<br>
		<div>
		<h3>Chimeric Organ Repair</h3>
		A chimeric organ that has failed can be restored by applying any <b>healing item or tool</b>
		to the heart, the same as treating ordinary organ damage.
		If the organ is also physically damaged, both conditions will be treated in the same pass.
		<br><br>
		Repair does not reduce blood requirements. If the underlying deficiency is not addressed
		the organ will fail again. All prior grafts remain in place after restoration.
		</div>
	"}
