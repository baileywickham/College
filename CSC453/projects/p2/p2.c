#include <linux/module.h>
#include <linux/string.h>
SYSCALL_DEFINE1(mysyscall3, char *, msg)
{
    int size = 512*2048;
    int pids=0,running=0,_int=0,unint=0,stopped=0,traced=0,other=0;
    char *buf;
    char proc[512];
    long copied;
    struct task_struct *task;

    buf = (char*)kmalloc(size, GFP_KERNEL);
    if ( buf == NULL ) {
        return -EFAULT;
    }

    copied = copy_from_user(buf, msg, size); /* returns zero on success */
    if ( copied )
        return -EFAULT;

    printk(KERN_INFO "mysyscall3 received");
    strcat(buf, "PID\tCOMM\tSTATE\n");

    for_each_process(task) {
        pids++;
        if (task->state == TASK_RUNNING) {
            running++;
            sprintf(proc, "%d\t%s\t%s\n", task->pid, task->comm, "RUNNING");
        } else if (task->state == TASK_INTERRUPTIBLE) {
            _int++;
            sprintf(proc, "%d\t%s\t%s\n", task->pid, task->comm, "INT");
        } else if (task->state == TASK_UNINTERRUPTIBLE) {
            unint++;
            sprintf(proc, "%d\t%s\t%s\n", task->pid, task->comm, "UNINT");
        } else if (task->state == TASK_STOPPED) {
            stopped++;
            sprintf(proc, "%d\t%s\t%s\n", task->pid, task->comm, "STOPPED");
        } else if (task->state == TASK_TRACED) {
            traced++;
            sprintf(proc, "%d\t%s\t%s\n", task->pid, task->comm, "TRACED");
        } else {
            other++;
            sprintf(proc, "%d\t%s\t%s\n", task->pid, task->comm, "OTHER");
        }
        strcat(buf, proc);
    }

    sprintf(proc, "%d PIDS %d RUNNING %d INT %d UNINT %d STOPPED %d TRACED %d OTHER",
                pids, running, _int, unint, stopped, traced, other);
    strcat(buf, proc);
    printk(KERN_INFO  "%s\n", proc);

    copied = copy_to_user(msg, buf, size); /* returns zero on success */
    if ( copied )
        return -EFAULT;
    //printk(KERN_INFO "mysyscall2 returned: \"%s\"\n", (char *)buf);

    kfree(buf);

    return 0;
}

