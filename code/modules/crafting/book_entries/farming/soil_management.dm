/datum/book_entry/soil_management
	name = "Soil Health and Nutrients"
	category = "Agriculture"

/datum/book_entry/soil_management/inner_book_html(mob/user)
	return {"
		<div style="text-align: left;">
			<h2>Understanding Soil Health</h2>
			Healthy soil is the foundation of successful farming. Soil provides plants with nutrients, water, and physical support. Managing soil health ensures consistent, high-quality harvests.<br>
			<br>
			<h2>The NPK System</h2>
			Soil nutrients are measured using the NPK system, with each nutrient having a maximum of 100 units:<br>
			<b>N - Nitrogen:</b> 0-200 units available<br>
			<b>P - Phosphorus:</b> 0-200 units available<br>
			<b>K - Potassium:</b> 0-200 units available<br>
			<br>
			<h2>Nutrient Consumption</h2>
			Plants consume nutrients throughout their growth cycle. During maturation, nitrogen is most important. During fruit/produce development, phosphorus becomes critical. Different plant families have varying requirements - check individual plant needs.<br>
			<br>
			<h2>Nutrient Sources</h2>
			Replenish soil nutrients through:<br>
			- Fertilizers (each type provides different NPK ratios)<br>
			- Some plants actually return nutrients to soil after harvest<br>
			- Allowing fields to rest between heavy-feeding crops<br>
			<br>
			<h2>Harvested Nutrient Replenishment</h2>
			When harvesting a plant a few things happen:<br>
			- It first replenishes its nutrient into its soil<br>
			- Then it checks the soil in its cardinal directions<br>
			- Then it replenishes nutrient to those soils<br>
			<br>
			<h2>Crop Rotation Benefits</h2>
			Rotating different plant families prevents soil depletion and breaks pest cycles:<br>
			<b>Heavy Feeders:</b> Consume large amounts of specific nutrients<br>
			<b>Light Feeders:</b> Minimal nutrient requirements<br>
			<b>Soil Builders:</b> Return nutrients to surrounding soil after harvest<br>
			<br>
			<h2>Signs of Poor Soil Health</h2>
			<b>Nutrient Deficiency:</b> Plants suffer continuous health damage when lacking required nutrients<br>
			<b>Water Stress:</b> Dry soil causes plant health to decline rapidly<br>
			<b>Weed Infestation:</b> Weeds compete for nutrients and water, harming plant growth<br>
			<br>
			<h2>Maintaining Soil Health</h2>
			- Monitor NPK levels and water regularly through examination<br>
			- Till soil before planting to improve growing conditions (lasts 15 minutes)<br>
			- Remove weeds by hand or with tools to prevent competition<br>
			- Water soil when it appears dry<br>
			- Apply appropriate fertilizers based on plant needs<br>
			- Consider irrigation channels for consistent water supply<br>
			<h2>Mushroom Mounds</h2>
			- Growing medium for mushrooms. Provides them with the ideal environment to flourish.<br>
			- Mushroom spores planted in this mound will get a boost to their growth and nutrient uptake.<br>
			- Other plants will not be able to establish a proper root system, stunting them if planted in this mound.<br>
		</div>
	"}
