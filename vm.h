#ifndef VM_H
#define VM_H

typedef struct Cond {
    char *param;
    char *op;
    int value;
} Cond;

typedef struct {
    int altitude;
    int speed;
    int heading;
    int position_x;
    int position_y;
} VMState;

void vm_init(VMState *vm);
void vm_execute_takeoff(VMState *vm);
void vm_execute_land(VMState *vm);
void vm_execute_set_speed(VMState *vm, int speed);
void vm_execute_set_heading(VMState *vm, int heading);
void vm_execute_set_altitude(VMState *vm, int altitude);
void vm_execute_goto(VMState *vm, int x, int y);
void vm_execute_print(VMState *vm);

int vm_compare(VMState *vm, const char *param, const char *op, int value);

#endif
