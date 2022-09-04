extends Node

var characters = {
	#Character 1
	"Adrian" : {
		"ImagePath" : "",
	},
	#Character 2
	"Felix" : {
		"ImagePath" : "", 
	},
	#Character 3
	"Lucy" : {
		"ImagePath" : "",
	},
	"Alec" : {
		"ImagePath" : "",
	},
}

var backgrounds = {
	"Dorm_livingroom_day" : {
		"Animation" : "Home",
		"Frame" : 0,
		"Location" : "Xenomium Academy, Male student Dormitory",
	},
	
	"School_classroom1-a_day" : {
		"Animation" : "School",
		"Frame" : 0,
		"Location" : "Xenomium Academy, Classroom 1-A",
	},
	
	"School_entrance" : {
		"Animation" : "School",
		"Frame" : 1,
		"Location" : "Xenomium Academy",
	},
	
	"School_hallway" : {
		"Animation" : "School",
		"Frame" : 2,
		"Location" : "Xenomium Academy",
	},
	
	"School_sunrise" : {
		"Animation" : "Outside",
		"Frame" : 0,
		"Location" : "Xenomium Academy",
	},
}

var expressions = {
	"Frown" : 0,
	"Frown_blush" : 1,
	"Open" : 2,
	"Open_blush" : 3,
	"Smile" : 4,
	"Smile_blush" : 5,
	"Closed_frown" : 6,
	"Closed_frown_blush" : 7,
	"Closed_open" : 8,
	"Closed_open_blush" : 9,
	"Closed_smile" : 10,
	"Closed_smile_blush" : 11,
}

#Add more if there are characters that should not be included
var unnecessary_characters =  [".",",",":","?"," "]

#Words that have (word_mastery_accuracy_bound) 80% mastery that is typed more than or equal to (word_mastery_cound_bound)1 times will be ignored in story mode
var word_mastery_accuracy_bound = 0.80
var word_mastery_count_bound = 1

#Transitions: Fade, Shards, Curtain, SpiralSquare, DiamondTilesCover, SpinningRectangle, Shade, Zip, HorizontalBars
#Character_Animations: UpDown, Shake
var dialogues = {
	"Chapter 1" : [
		{
			"character" : "Narrator",
			"location" : "Dorm_livingroom_day",
			"location_tint" : "#cbcbcb",
			"dialogue" : "After he had returned from class, Felix dropped all the gifts and letters he had been holding on the table. The gifts were from the female students of Xenomium Academy. Felix’s rough handling caused some of the carefully wrapped gifts to fall off the table.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Adrian, who was reading a book on the sofa, frowned as he picked them up. His name was written in cursive on the wrapping paper.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Adrian",
			"outfit" : "Summer",
			"expression" : "Open_blush", 
			"dialogue" : "Why are you even taking my presents?",
			"position" : "LEFT",
			"character_animation" : [{"character" : "Adrian", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Felix",
			"outfit" : "Casual",
			"expression" : "Frown",
			"dialogue" : "What was I supposed to do when they gave it to me thinking I was you?",
			"position" : "RIGHT",
			"character_animation" : [{"character" : "Felix", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Adrian",
			"expression" : "Open",
			"dialogue" : "Are you not going to grow your hair back out again?",
			"character_animation" : [{"character" : "Adrian", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Felix",
			"expression" : "Frown_blush",
			"dialogue" : "...it’s hot",
			"character_animation" : [{"character" : "Felix", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix smiled playfully as he picked up the carefully wrapped handmade cookies next to him. He unraveled the ribbon with a touch of excitement and threw the cookies into his mouth one by one.",
			"skip_dialogue" : true,
			"hide_all_characters" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Adrian shook his head as he looked at Felix’s short hair. After the summer break, Felix’s long hair was cut short. He was then frequently mistaken for Adrian, his twin brother.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Their face, height and voice were so similar that it was difficult to tell them apart. The only difference between them was the length of their hair.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Adrian, the younger twin, had his short blonde hair tucked behind his ear. He was neatly dressed in a school uniform. The older twin Felix, however, had long blonde hair that hung over his shoulders. His shirt was never buttoned properly.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "This was the method of distinguishing the Berg twins that was widely known among academy students and teachers. ",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix and Adrian had been following these ‘rules’ for years now. It annoyed them when people mistook them for another twin. But, on the first day of the new semester, Felix broke the rule; his once long blonde hair had been cut short.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Adrian",
			"expression" : "Open",
			"dialogue" : "People might get confused",
			"show_character" : ["Adrian"],
		},

		{
			"character" : "Felix",
			"show_character" : ["Felix"],
			"expression" : "Open",
			"dialogue" : "Then let's change it. From now on, you grow it out",
		},

		{
			"character" : "Adrian",
			"dialogue" : "No one will be able to tell us apart now, not even our parents",
			"character_animation" : [{"character" : "Adrian", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix chuckled when he heard Adrian’s words. If it were their mother and father, he really thought that that would be the case.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Felix",
			"expression" : "Smile",
			"dialogue" : "What does the length of my hair have to do with it?",
			"character_animation" : [{"character" : "Felix", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix put the last cookie in his mouth and dusted off the crumbs from his hands.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Felix",
			"expression" : "Open",
			"dialogue" : "As long as we are the Princes of Berg, they will not care who we really are.",
			"character_animation" : [{"character" : "Felix", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix’s next class would only have a short break. With a tired expression, he stretched his arms and stood up.",
			"skip_dialogue" : true,
		},
		
		{
			"character" : "Felix",
			"expression" : "Open_blush",
			"dialogue" : "Why are you so free when I'm so busy? Don't you have a class?",
			"character_animation" : [{"character" : "Felix", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Adrian",
			"expression" : "Frown",
			"dialogue" : "What do you mean you're free?",
			"character_animation" : [{"character" : "Adrian", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Adrian",
			"dialogue" : "I need to get to work on the student council right away. There's also work at the library.",
		},

		{
			"character" : "Narrator",
			"dialogue" : "Adrian was the president of the student council as well as the librarian. It was a passion Felix could never understand.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Adrian",
			"expression" : "Frown_blush",
			"dialogue" : "That's why I told you to take the required courses beforehand. Aren't you busy right now because you skipped classes and played hard?",
			"character_animation" : [{"character" : "Adrian", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix quickly left the room with his bag when his younger brother began nagging. Adrian couldn’t be stopped from his lecture once he started.",
			"skip_dialogue" : true,
			"remove_all_characters" : true,
		},

		{
			"character" : "Narrator",
			"location" : "School_sunrise", 
			"transition" : "Curtain",
			"dialogue" : "The second semester began anew.",
			"skip_dialogue" : true,
		},
		{
			"character" : "Narrator",
			"location" : "School_entrance", 
			"transition" : "Curtain",
			"dialogue" : "Autumn had arrived, but the campus was still in its last leg of summer. The stinging heat of the sun beating down on the crown, and the chirping cicadas sounded like rain from the fresh green trees.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Walking on the hot campus, Felix thought about what Adrian said.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Now no one will be able to tell us apart. Even our parents.",
			"skip_dialogue" : true,
		},
		
		{
			"character" : "Narrator",
			"dialogue" : "It was true that even their parents wouldn't be able to tell them apart. Felix remembered the faces of his mother and father, who repeatedly called him Adrian.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "But it was not true that no one would be able to tell them apart. Since there was 'her'.",
			"skip_dialogue" : true,
		},
		{
			"character" : "Narrator",
			"dialogue" : "Felix was walking along the road, kicking a stone, when he came to a complete stop. Speak of the devil and he shall appear. The person walking from across the street was none other than ‘her’.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Felix",
			"outfit" : "Summer",
			"expression" : "Open",
			"dialogue" : "Lucy Keenan.",
			"position" : "MIDDLE",
		},

		{
			"character" : "Narrator",
			"dialogue" : "Her wavy, light brown hair was neatly braided. She was wearing a shirt that was buttoned up to the neck in this hot weather.",
			"skip_dialogue" : true,
			"hide_character" : ["Felix"],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Even her steps were straight and upright. She was walking down the street looking at a small note and the young lady suddenly looked up as if she felt someone’s eyes on her.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Lucy",
			"outfit" : "Summer",
			"forced_name" : "Narrator",
			"expression" : "Open",
			"dialogue" : "Lucy Keenan’s eyes widened...",
			"position" : "MIDDLE",
			"skip_dialogue" : true,
		},

		{
			"character" : "Lucy",
			"forced_name" : "Narrator",
			"expression" : "Closed_frown_blush",
			"dialogue" : "... then narrowed",
			"skip_dialogue" : true,
		},

		{
			"character" : "Lucy",
			"forced_name" : "Narrator",
			"expression" : "Open",
			"dialogue" : "... then widened again, as she stood upon discovering Felix.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Lucy",
			"forced_name" : "Narrator",
			"expression" : "Closed_frown_blush",
			"dialogue" : "No, it’s getting narrow again. Think about it.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix laughed quietly to himself. She must be wondering whether the Berg in front of her is Adrian Berg or Felix Berg. Felix gently raised the corners of his lips and smiled softly. It was the smile that Adrian often wore.",
			"skip_dialogue" : true,
			"hide_character" : ["Lucy"],
		},

		{
			"character" : "Narrator",
			"dialogue" : "A sweet smile that anyone could have mistaken him for Adrian. Just as expected, lucy Keenan strode towards him, with a friendly smile on her face. Seeing this, Felix felt a strange sense of victory.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Lucy",
			#Lucy Keenan approaching Felix with a small and clear voice, stopped walking.
			"dialogue" : "Adrian sunbaenim, there's a meeting in the student council room later",
			"expression" : "Open_blush",
			"show_character" : ["Lucy"],
		},

		{
			"character" : "Lucy",
			"forced_name" : "Narrator",
			"expression" : "Closed_frown_blush",
			"dialogue" : "Lucy Keenan, who was approaching him with a small and clear voice, stopped walking. Soon after, the smile disappeared without a trace from her face, replaced by embarrassment.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Lucy",
			"expression" : "Frown_blush",
			"dialogue" : "Ah...",
		},

		{
			"character" : "Narrator",
			"dialogue" : "Lucy Keenan made a sound that he couldn’t understand, she immediately turned her body around. Then she began to return to the path where she had been earlier at a very fast pace.",
			"skip_dialogue" : true,
			"hide_character" : ["Lucy"],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix raised an eyebrow as she watched the back of Lucy Keenan disappear. The sense of victory that filled his heart was completely gone. He ruffled his blonde hair wildly.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Felix",
			"outfit" : "Summer",
			"dialogue" : "This is pissing me off.",
			"expression" : "Frown",
			"position" : "MIDDLE",
			"show_character" : ["Felix"],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix became aware of Lucky Keenan's existence in the first semester of that year. It was one spring day when he and Adrian wore the same hat. Felix had rolled up his long hair and hidi t under the mat, making him indistinguishable from Adrian",
			"skip_dialogue" : true,
			"hide_character" : ["Felix"],
		},

		{
			"character" : "Narrator",
			"location" : "School_hallway",
			"transition" : "Curtain",
			"dialogue" : "Not only other students and teachers, but their best friend Alec couldn't tell them apart as well. He stood in front of them and tilted his head.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Alec",
			"outfit" : "Summer",
			"expression" : "Frown",
			"dialogue" : "What? What kind of trick is this? Hurry up and take it off. I can't tell who's who.",
			"position" : "MIDDLE",
		},

		{
			"character" : "Narrator",
			"dialogue" : "The twins bursted laughing when they saw his confused expression.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Felix",
			"forced_name" : "Adrian and Felix",
			"dialogue" : "No, our father is coming today.",
			"expression" : "Smile",
			"show_character" : ["Felix"],
			"position" : "LEFT",
			"show_more_characters" : [
				{
					"character" : "Adrian",
					"outfit" : "Summer",
					"expression" : "Smile",
					"position" : "RIGHT",
				},
			],
		},

		{
			"character" : "Alec",
			"dialogue" : "The Duke of Berg?",
			"expression" : "Open",
		},

		{
			"character" : "Narrator",
			"dialogue" : "Duke Arthur Berg was one of the most powerful and wealthy people within the Veros Empire. Xenomium Academy had received many large donations from him.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "In an effort to avoid being caught by their father, the twins, who were well aware of their father's strict and cold personality, came to school immaculately dressed. Felix, who didn't usually wear a tie since he found it irksome, was even wearing one.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Felix",
			#Felix straightening his tie
			"dialogue" : "I can't help it. Just wait until my father leaves.",
			"expression" : "Frown",
			"character_animation" : [{"character" : "Felix", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Whenever his father came to visit, Feli and Adrian would also be called to the principal's office. He wanted his annoying father's visit to the academy to end sooner rather than later.",
			"skip_dialogue" : true,
			"hide_all_characters" : true,
		},

		{
			"character" : "Lucy",
			"dialogue" : "There...",
			"show_character" : ["Lucy"],
		},

		{
			"character" : "Narrator",
			"dialogue" : "That was when it happened. Felix and Adrian turned to face the small voice behind them. A female student with mysterious sapphire eyes looked up at them.",
			"skip_dialogue" : true,
			"show_character" : ["Felix", "Adrian"],
		},
		
		{
			"character" : "Narrator",
			"dialogue" : "With a piece of paper in her hand that read ‘Library New Directory’, it appeared that she had come to deliver the list to Adrian, the head of the library.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Only then did Felix recall that the girl was a member of the library staff he had seen several times.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix was bored, so he had the sudden urge to pull a prank. He reached out to the girl with a soft, friendly smile before Adrian could even step forward.",
			"skip_dialogue" : true,
		},
			
		{
			"character" : "Narrator",
			"dialogue" : "He waited for the girl to hand him the list. But the girl just looked down at Felix's hand while holding the paper.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Lucy",
			#Lucy lifted her head with a tense expression on her face and hesistated
			"dialogue" : "I... ",
			"expression" : "Closed_frown_blush",
		},

		{
			"character" : "Lucy",
			#Lucy immediately handed the paper to Adrian
			"dialogue" : "This is the new list of book clubs I want to give to Adrian sunbaenim.",
			"expression" : "Frown_blush",
		},

		{
			"character" : "Adrian",
			"dialogue" : "Hey, don't play around.",
			"expression" : "Frown",
			"character_animation" : [{"character" : "Adrian", "anim" : "Shake"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Adrian elbowed Felix and took the paper from Lucy.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Adrian",
			"dialogue" : "I'm sorry, Lucy. I've been busy with the student council, so it's like I've been putting a huge burden on you. I am the head of the library.",
			"expression" : "Open",
			"character_animation" : [{"character" : "Adrian", "anim" : "QuickUpDown"}],
		},
		
		{
			"character" : "Narrator",
			"dialogue" : "The girl, Lucy, shook her head. Her face red after hearing Adrian’s words.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Lucy",
			"dialogue" : "No! I'm the second-year manager! I'm not that busy either.",
			"expression" : "Open_blush",
		},

		{
			"character" : "Adrian",
			"dialogue" : "Okay, thank you. I look forward to your kind cooperation.",
			"expression" : "Smile",
			"character_animation" : [{"character" : "Adrian", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Adrian answered with a gentle tone. Lucy, who had been standing with a tense look all the time, was shining brightly for the first time.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "And Felix stood there, perplexed, staring at the scene. How did you know? He didn't have a nametag on or a book in his hand that had his name.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "However, the girl did not hesitate to conclude that he was not Adrian. She was able to tell the twins apart at a glance.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Narrator",
			"dialogue" : "Lucy, who delivered her list, politely bid her seniors goodbye and left.",
			"skip_dialogue" : true,
			"hide_character" : ["Lucy"],
		},

		{
			"character" : "Felix",
			"dialogue" : "What exactly is her name?",
			"expression" : "Frown", 
			"character_animation" : [{"character" : "Felix", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix asked, looking at the corner where she disappeared.",
			"skip_dialogue" : true,
		},

		{
			"character" : "Alec",
			"dialogue" : "What, Felix! Are you interested?",
			"expression" : "",
			"show_character" : ["Alec"],
		},

		{
			"character" : "Adrian",
			"dialogue" : "Hey, you can't be... Don't do that. Lucy is...",
			"expression" : "Frown",
			"character_animation" : [{"character" : "Adrian", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "But before Adrian could finish speaking, Felix raised his hand to stop him.",
			"skip_dialogue" : true,
		},
		
		{
			"character" : "Felix",
			"dialogue" : "No. You don't have to tell me I was just curious.",
			"expression" : "Frown_blush",
			"character_animation" : [{"character" : "Felix", "anim" : "QuickUpDown"}],
		},

		{
			"character" : "Narrator",
			"dialogue" : "Felix reasoned that she had simply guessed it. That was a possibility. If not, how could she tell them apart at a glance when even their parents couldn't",
			"skip_dialogue" : true,
		},
	],
}

var quests = [
	{
		"Type" : "Daily",
		"Desc" : "Type 5 words"
	}
]
