class Character:
    def __init__(self, name, speed, team):
        self.name = name
        self.speed = speed
        self.team = team 
        self.initiative = 0
        self.turn_count = 0
        self.turn_order = [] 
    
    def update_initiative(self, delta_t):
        self.initiative += self.speed * delta_t
    
    def take_turn(self, turn_number):
        self.turn_count += 1
        self.turn_order.append(turn_number)
        self.initiative -= 1000

def simulate_combat(characters, delta_t=0.01, max_turns=50):
    turn_number = 0
    while turn_number < max_turns:
        for char in characters:
            if char.initiative < 1000:
                char.update_initiative(delta_t)
        
        ready_chars = [char for char in characters if char.initiative >= 1000]
        
        if ready_chars:
            ready_chars.sort(key=lambda x: (x.initiative, x.speed), reverse=True)
            
            for char in ready_chars:
                turn_number += 1
                char.take_turn(turn_number)                
                if turn_number >= max_turns:
                    break

def main():
    players = [
        Character("Verso", speed=3077, team='player'),
        Character("Maelle", speed=2595, team='player'),
        Character("Monoco", speed=2099, team='player'),
    ]
    
    ennemies = [
        Character("Enemy 1", speed=1971, team='enemy'),
        Character("Enemy 2", speed=1659, team='enemy'),
        Character("Enemy 3", speed=1596, team='enemy'),
    ]
    
    all_characters = players + ennemies
    
    simulate_combat(all_characters, delta_t=0.01, max_turns=300)
    print("Turn order")
    global_turn_order = []
    for char in all_characters:
        for turn_num in char.turn_order:
            global_turn_order.append((turn_num, char))
    global_turn_order.sort(key=lambda x: x[0])
    
    for turn_num, char in global_turn_order:
        color = '\033[94m' if char.team == 'player' else '\033[91m'
        reset = '\033[0m'
        print(f"Turn {turn_num:2d}: {color}{char.name}{reset}")

if __name__ == "__main__":
    main()