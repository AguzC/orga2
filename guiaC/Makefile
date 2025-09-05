CC = gcc
CFLAGS = -Wall -Wextra -pedantic -MMD -MP -g


all: $(TARGET)
	./$(TARGET)
	
make debug: $(TARGET)
	gdb $(TARGET) 

OBJS = $(SRCS:.c=.o)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

-include £(OBJS:.o=.d)

clean:
	rm *.o $(TARGET) *.d
.PjuHONY: all clean
