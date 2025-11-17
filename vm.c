#include <stdio.h>
#include <string.h>
#include "vm.h"

void vm_init(VMState *vm){
    vm->altitude = 0;
    vm->speed = 0;
    vm->heading = 0;
    vm->position_x = 0;
    vm->position_y = 0;
}

void vm_execute_takeoff(VMState *vm){
    vm->altitude = 100;
    printf("Taking off\n");
}

void vm_execute_land(VMState *vm){
    vm->altitude = 0;
    printf("Landing\n");
}

void vm_execute_set_speed(VMState *vm, int speed){
    vm->speed = speed;
    printf("Speed set to %d\n", speed);
}

void vm_execute_set_heading(VMState *vm, int heading){
    vm->heading = heading;
    printf("Heading set to %d\n", heading);
}

void vm_execute_set_altitude(VMState *vm, int altitude){
    vm->altitude = altitude;
    printf("Altitude set to %d\n", altitude);
}

void vm_execute_goto(VMState *vm, int x, int y){
    vm->position_x = x;
    vm->position_y = y;
    printf("Moving to (%d, %d)\n", x, y);
}

void vm_execute_print(VMState *vm){
    printf("State: altitude=%d speed=%d heading=%d position=(%d,%d)\n",
           vm->altitude, vm->speed, vm->heading, vm->position_x, vm->position_y);
}

int vm_compare(VMState *vm, const char *param, const char *op, int value){
    int param_val = 0;
    if(strcmp(param,"speed")==0) param_val = vm->speed;
    else if(strcmp(param,"altitude")==0) param_val = vm->altitude;
    else if(strcmp(param,"heading")==0) param_val = vm->heading;

    if(strcmp(op,"==")==0) return param_val == value;
    if(strcmp(op,"!=")==0) return param_val != value;
    if(strcmp(op,">")==0) return param_val > value;
    if(strcmp(op,"<")==0) return param_val < value;
    if(strcmp(op,">=")==0) return param_val >= value;
    if(strcmp(op,"<=")==0) return param_val <= value;
    return 0;
}
