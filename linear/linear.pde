//generate linear search visuals within a certain range!
String digitToX(int digit) {
    // Replace each digit with an 'X'
    String chars = "";
    for (int k = 0; k < String.valueOf(digit).length(); k++) {
        chars += "X";
    }
    return chars;
}


String[] linearSearch(int[] array , int target) {
    //if not found the result array will increase by 2!
    String[] result = new String[array.length + 2];    
    
    result[array.length] = target + " |";
    
    for (int i = 0;i < array.length;i++) {
        String step = target + " |";
        for (int j = 0;j < array.length;j++) {
            if (j < i) {
                step += "   " + digitToX(array[j]);
            }
            else step += "   " + array[j];
        };
        result[i] = step;
        
        if (array[i] == target) {
            result[i + 1] = target + " | FOUND at index " + i;
            
            //we need to do pruning of empty blank now which we are not using!
            String pruned[] = new String[i + 2];
            
            for (int k = 0;k < pruned.length;k++) {
                pruned[k] = result[k];
            }
            
            return pruned;
        }
        
        //keep filling the extra useless array of all XX! (Saving CPU!😎)
        result[array.length] += "   " + digitToX(array[i]);
    }
    
    result[array.length + 1] = "NOT FOUND";
    return result;
}

int[] generateRandomArray(int n, int start, int end) {
    int[] array = new int[n];
    for (int i = 0; i < n; i++) {
        array[i] = int(random(start, end));
    }
    return array;
}

int selectRandomTarget(int[] array) {
    float rand = random(1);
    if (rand < 0.9) { // 90% of the time, select a random index from the array
        int index = int(random(array.length));
        return array[index];
    } else { // 10% of the time, return an arbitrary value not found in the array
        int maxValue = max(array);
        return maxValue + 1; // This value will not be found in the array
    }
}

//Discalimer: The Mouse click function is at last of the file dues to varibale dependency & resetting!

//Scroll.pde #copy paste (nothing to check)

String[] sentences = new String[]{"Please click to start a demo of linear search!"};

//joystick(you can change these varibales to play with!)
//* canvas size alsofalse under this category!
int desired = 1; //the number of lines that will be displayed
int fontSize = 20;
int maxi = 5; //maximun number of lines that can be displayed at once


//utility varibales(don't touch these! changing these varibales will break the code!)
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
        //there is apossibility that we have scrolled one line! so we need to stop after
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
    background(255);
    
    //if the screen is scrolling then decrease the scroll to make it look like scrolling!
    if (scrolling) {
        scroll --;
    }
    //update thescrolling state according to the estimation of function! 
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
        //screenis overflowing start scrolling!
        if (desired > maxi && desired <=  sentences.length) scrolling = true;
    }
}

//the mouse click functionality!
void mouseClicked() {
    scroll = fontSize;
    desired = 1;
    scrolling = false;
    int[] intArray = generateRandomArray(10, 1, 100);
    sentences = linearSearch(intArray, selectRandomTarget(intArray));
}