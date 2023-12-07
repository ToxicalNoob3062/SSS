//these are the sentences that will be displayed
//#Raven Poem!
String[] sentences = new String[]{
    "Once upon a midnight dreary, while I pondered, weak and weary,",
    "Over many a quaint and curious volume of forgotten lore—",
    "While I nodded, nearly napping, suddenly there came a tapping,",
    "As of some one gently rapping, rapping at my chamber door.",
    "“’Tis some visitor,” I muttered, “tapping at my chamber door—",
    "Only this and nothing more.”",
    "Ah, distinctly I remember it was in the bleak December;",
    "And each separate dying ember wrought its ghost upon the floor.",
    "Eagerly I wished the morrow;—vainly I had sought to borrow",
    "From my books surcease of sorrow—sorrow for the lost Lenore—",
    "For the rare and radiant maiden whom the angels name Lenore—",
    "Nameless here for evermore."
};


//joystick (you can change these varibales to play with!)
//* canvas size also false under this category!
int desired = 1; //the number of lines that will be displayed
int fontSize = 20;
int maxi = 5; //maximun number of lines that can be displayed at once


//utility varibales (don't touch these! changing these varibales will break the code!)
int timer = millis();
boolean scrolling = false;
int scroll = fontSize; //starting position for drawFunction!

//draws the text from starting index to ending index top to bottom from position!
//returns decision to stop scrolling or not assuming the screen is in scrolling condition at that moment!
//(#😎 intelligent decision making function!) 

boolean drawText(String[] sentences, int start, int end, int position) {
    //assume that the screen is is scrolling state now!
    boolean isScrolling = true;
    
    //these are maths! (not gonna explain!)
    int lineGap = ceil(height / maxi);
    lineGap += ((lineGap - fontSize - 5) / (maxi - 1));
    
    for (int i = start; i < end; i++) {
        
        text(sentences[i], 5 , position);
        
        //while drawing the lines, everytime we draw something on screen starting position
        //there is a possibility that we have scrolled one line! so we need to stop after
        //scrolling one line! #decision-making
        if (position == fontSize) isScrolling = false;
        
        position += lineGap;
    }
    
    //decision made by function if the scrolling needs to be stopped or not!!
    return isScrolling; 
}

//setup text size , color  and lineGap
void setup() {
    size(600, 400); //canvas
    textSize(fontSize); 
    fill(color(0,0,255));//blue
}

void draw() {
    //there is nothing to scroll more and show so no need to draw anything! we are at our end!
    if (desired > sentences.length) return;
    
    //clear the screen everytime!
    background(0);
    
    //if the screen is scrolling then decrease the scroll to make it look like scrolling!
    if (scrolling) {
        scroll --;
    }
    //update the scrolling state according to the estimation of function! 
    scrolling = drawText(sentences, 0, desired, scroll);
}

//tell about if dormancy period is over or not!
boolean isAllowed() { 
    int currentTime = millis();
    int diff = currentTime - timer;
    if (diff > 500) {
        timer = currentTime;
        return true;
    };
    return false;
};

//increase desired by 1 if allowed by timer & if not scrolling
void keyPressed() {
    if (isAllowed() && !scrolling) {
        desired = desired<= sentences.length ? desired + 1 : desired;  
        //screen is overflowing start scrolling!
        if (desired > maxi && desired <=  sentences.length) scrolling = true;
    }
}