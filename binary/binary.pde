//will generate each binary search step!
String generateStep(int[] array , int start , int end, int target) {
    String step = target + " |";
    for (int i = 0; i < array.length; i++) {
        if (i >=  start && i <= end) {
            step += "   " + array[i];
        } else {
            step += "   " + digitToX(array[i]); 
        }
    }
    return step;
}

//binary search algorithm to generate test cases!
String[]binarySearch(int[] array, int target) {
    //initializing the result array
    int start = 0;
    int last  = array.length - 1;
    
    //start calculating steps
    int staticInd = 1;
    
    //let keep more memory so we can prune later!
    String[] result =  new String[array.length + 10]; 
    result[0] = generateStep(array, start, last + 1, target);
    
    while(last >= start) {
        int mid = (start + last) / 2;
        if (array[mid] == target) {
            result[staticInd] = target + " |" + "   Found at index: " + mid;
            
            //we need to do pruning of empty blank now which we are not using!
            String pruned[] = new String[staticInd + 1];
            
            for (int k = 0;k < pruned.length;k++) {
                pruned[k] = result[k];
            }
            
            return pruned;
        } 
        else if (array[mid] > target) {
            last = mid - 1;
        } 
        else{
            start = mid + 1;
        }
        result[staticInd] = generateStep(array, start, last, target);
        staticInd++;
    }
    result[staticInd] = "Not Found!";
    return result;
}

//Discalimer: The Mouse click function is at last of the file dues to varibale dependency & resetting!

//copied from linear.pde (nothing to check!)

String digitToX(int digit) {
    // Replace each digit with an 'X'
    String chars = "";
    for (int k = 0; k < String.valueOf(digit).length(); k++) {
        chars += "X";
    }
    return chars;
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

//Scroll.pde #copy paste (nothing to check)

String[] sentences = new String[]{"Please click to start a demo of binary search!"};

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
    int[] intArray = generateRandomArray(10, 1, 1000); 
    sentences = binarySearch(sort(intArray), selectRandomTarget(intArray));
}