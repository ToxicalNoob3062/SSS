//implemented it by mistake but invested time in it so just wanted to submit it at extra just
//for self satifaction as if my time was not wasted! XD
String[] sentences = new String[]{
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
};

//writes a sentence on screen at position!
void writeSentence(String sentence, int position) {
    textSize(30);
    fill(color(0,0,255));
    text(sentence, 5,position);
}

//writes the sentences on screen from start to end at screenPosition
void writeOnPage(String[] sentences, int start , int end, int screenPosition) {
    int gapConstant = 0;
    for (int i = start; i < end; i++) {
        writeSentence(sentences[i], screenPosition + (gapConstant * lineGap));
        gapConstant++;
    }
}

void setup() {
    size(512, 512); //set the size of the screen
}

//joystick-only change these variables to change the behaviour of the program!
int maxi = 5; //how many sentences to draw at a time at max on screen!
int timer =  millis(); //timer to prevent multiple keypresses
int desired = 1;  //how many sentences to draw
int lineGap = 100; //gap between sentences;


//let start drawing from y=30 because drawing from 0 takes the text outside of screen!
//scroll is the y position of the first sentence which we reduce to 0 to scroll up the screen!
int scroll = 30; 

//this is a very important concept ! 
//scroll cursor divides the array into two parts! which we draw one after another on screen!
//part 1: (scrollCursor to screenMaximum)!
//part 2: (0 to scrollCursor)! #if part1 didn't fill the screen with max sentences!
int scrollCursor = 0; 

void draw() {
    //clear the screen
    background(255,255,255);
    
    //draws the part1
    writeOnPage(sentences, scrollCursor,min(scrollCursor + maxi, desired) ,scroll);
    
    //implement scroll feature!
    if (desired > maxi) {
        
        //draws the part2 as part1 can't fill the screen with max if desired > maxi
        int drawn = (min(scrollCursor + maxi, desired) - scrollCursor); //how many sentences drawn in part1
        int needToDraw = maxi - drawn; //how many sentences to draw in part2
        writeOnPage(sentences,0,needToDraw,(drawn * lineGap) + scroll); //draw part2
        
        //scroll = 0 means we have scrolled up the first line from the screen!
        if (scroll <=  0) {
            //reset scroll back to line gap again for scrolling up the new first line from screen!
            scroll = lineGap;
            
            //increase scrollCursor to ommit the first line from part1!
            scrollCursor++;
            
            //for reversing the case of part1 being empty and part2 is of max length!
            if (scrollCursor >=  desired) {
                scrollCursor = 0;
            }
        }
        //reducing scroll to scroll up the screen!
        scroll -= 1;
    };
}

//manges the timer to prevent multiple keypresses
boolean isAllowed() { 
    int currentTime = millis();
    int diff = currentTime - timer;
    if (diff > 500) {
        timer = currentTime;
        return true;
    };
    return false;
}

//increase desired by 1 if allowed by timer
void keyPressed() {
    if (isAllowed()) {
        desired = desired<sentences.length ? desired + 1 : desired;
    }
}