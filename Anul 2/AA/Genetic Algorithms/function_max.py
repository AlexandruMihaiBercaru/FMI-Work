import math
import numpy as np
import random
import matplotlib.pyplot as plt

class Encoder:
    def __init__(self, _interval, _precision):
        self.interval = _interval
        self.precision = _precision
        
    def encode(self):
        a, b = self.interval[0], self.interval[1]
        bit_length = math.floor(math.log(((b - a) * pow(10, self.precision)), 2)) + 1
        self.d = (b - a) / pow(2, bit_length)
        self.discrete_intervals = [a + x * self.d for x in range(pow(2, bit_length))]
        self.discrete_intervals.append(b)
        return bit_length,self.d, self.discrete_intervals
    
            
    def binary_to_decimal(self, bits):
        nr = 0
        for k in range(1, len(bits)+1):
            nr += int(bits[-k]) * pow(2, k-1)
        #return nr
        valoare = self.interval[0] + nr * self.d 
        return format(valoare, "." + str(self.precision) + "f")
    
    def apply_func(self, func, value):
        return f[0] * (value ** 2) + f[1] * value + f[2]


class Chromosome:
    def __init__(self, _bitrepr, _value, _fitness):
        self.bitrepr = _bitrepr
        self.value = _value
        self.fitness = _fitness
        
        
        
class Population:
    def __init__(self, _size, _f, chromosomes = None):
        self.size = _size
        self.f = f
        self.chromosomes = chromosomes
        
        
    def print_current_population(self, fileobj):
        for i, c in enumerate(self.chromosomes):
            fileobj.write("{:>4}: {}   x={:>9}   f={}\n".format(i+1, c.bitrepr, c.value, c.fitness))
    
    
    def bin_search(self, nr, intervals):
        st = 0
        dr = len(intervals) - 1
        p = (st + dr) // 2
        while st < dr - 1: # ma opresc cand gasesc st=i, dr=i+1 si afisez i+1
            if nr < intervals[p]:
                dr = p 
            elif nr > intervals[p]:
                st = p
            else:
                return p
            p = (st + dr)// 2
        return dr
            
        
    # generarea aleatorie a primei populatii
    def generate_first(self, enc):
        individuals = []
        l, d, discrete_intervals = enc.encode()
        for i in range(1, self.size+1):
            bits = []
            for j in range(1, l+1):
                b = '0' if np.random.uniform() < 0.5 else '1'
                bits.append(b)
            bits = "".join(bits)
            fixed_point_value = enc.binary_to_decimal(bits)
            fitness_value = enc.apply_func(f, float(fixed_point_value))
            
            individuals.append(Chromosome(bits, fixed_point_value, fitness_value))
        self.chromosomes = individuals
        
        
    def __str__(self):
        for i, c in enumerate(self.chromosomes):
            print("{:>4}: {}   x={:>9}   f={}\n".format(i+1, c.bitrepr, c.value, c.fitness))
            
        
class Algorithm:
    def __init__(self, _n, _interval, _f, _p, _pc, _pm, _steps, parentpop = None, childrenpop = None):
        self.pop_size = _n
        self.interval = _interval
        self.function = _f
        self.precision = _p
        self.crossover_p = _pc
        self.mutation_p = _pm
        self.alg_steps = _steps
        
        
    def initialize_population(self, encoder, first_pop):
        first_pop.generate_first(encoder)
        self.file.write("Populatia initiala:\n")
        first_pop.print_current_population(self.file)
        
    def afis_probabilitati_intervale(self, ps, cummps):
        f = self.file
        f.write("Probabilitati selectie\n")
        for i, p in enumerate(ps):
            f.write("cromozom {:>4} probabilitate {}\n".format(i+1, p))
        f.write("\nIntervale probabilitati selectie\n")
        for p in cummps:
            f.write(str(p) + "  ")
        f.write("\n")
            
    def afis_cromozomi_selectati(self, U, chromosomes_idx): 
        f = self.file
        for i, u in enumerate(U):
            f.write("u={}  selectam cromozomul {}\n".format(u, chromosomes_idx[i]))
        
        
    def afis_participare_crossover(self, pc, U, chromosomes):
        f = self.file
        f.write(f"\nProbabilitatea de incrucisare: {pc}\n")
        for i, u in enumerate(U):
            if u < pc:
                f.write("{:>4}: {} u={} < {} participa\n".format(i+1, chromosomes[i].bitrepr, u, pc))
            else:
                f.write("{:>4}: {} u={}\n".format(i+1, chromosomes[i].bitrepr, u))
            
    
    def selection(self, current_population, pas):
        # calculam probabilitatea de selectie pentru fiecare cromozom din populatie
        # si capetele intervalelor de probabilitate
        # pentru populatia initiala (pas = 0), vom afisa probabilitatile si intervalele de probabilitate 
        fitnesses = [c.fitness for c in current_population.chromosomes]
        F = sum(fitnesses)
        selection_probabs = [f / F for f in fitnesses]
        cumm_probabs = np.cumsum(np.array([0] + selection_probabs))
        
        rvs = np.random.uniform(size = len(fitnesses))
        selected_chromosomes = [current_population.bin_search(u, cumm_probabs.tolist()) for u in rvs]
        intermediary_pop_1 = Population(len(selected_chromosomes), current_population.f,
                                        [current_population.chromosomes[i-1] for i in selected_chromosomes])
        
        if pas == 0:
            self.afis_probabilitati_intervale(selection_probabs, cumm_probabs)
            self.afis_cromozomi_selectati(rvs, selected_chromosomes)
            self.file.write("\nDupa selectie:\n")
            intermediary_pop_1.print_current_population(self.file)
            
        return intermediary_pop_1


    def two_crossover_operator(self, chr1, chr2, l, pas, break_points):
        if break_points == 1:
            i = np.random.randint(0, l+1)
            new1 = chr1[:i] + chr2[i:]
            new2 = chr2[:i] + chr1[i:]
        else:
            if break_points == 2:
                i1 = np.random.randint(0, l+1)
                i2 = np.random.randint(0, l+1)
                while i1 == i2:
                    i1 = np.random.randint(0, l+1)
                    i2 = np.random.randint(0, l+1)
                if i1 >= i2:
                    i1, i2 = i2, i1
                new1 = chr1[:i1] + chr2[i1:i2] + chr1[i2:]
                new2 = chr2[:i1] + chr1[i1:i2] + chr2[i2:]
        
        if pas == 0  :
            if break_points == 1:
                self.file.write(f"{chr1}  {chr2}  punct = {i}\n")
            else:
                if break_points == 2:
                    self.file.write(f"{chr1}  {chr2}  puncte = {i1} {i2}\n")
            self.file.write(f"Rezultat:    {new1}  {new2}\n")
        return new1, new2
        
        
    def three_crossover_operator(self, chr1, chr2, chr3, l, pas, break_points):
        if break_points == 1:
            i = np.random.randint(0, l+1)
            new1 = chr1[:i] + chr2[i:]
            new2 = chr2[:i] + chr3[i:]
            new3 = chr3[:i] + chr1[i:]
        else:
            if break_points == 2:
                i1 = np.random.randint(0, l+1)
                i2 = np.random.randint(0, l+1)
                while i1 == i2:
                    i1 = np.random.randint(0, l+1)
                    i2 = np.random.randint(0, l+1)
                if i1 >= i2:
                    i1, i2 = i2, i1
                new1 = chr1[:i1] + chr2[i1:i2] + chr3[i2:]
                new2 = chr2[:i1] + chr3[i1:i2] + chr1[i2:]
                new3 = chr3[:i1] + chr1[i1:i2] + chr2[i2:]
        if pas == 0:
            if break_points == 1:    
                self.file.write(f"{chr1}  {chr2}  {chr3}  punct = {i}\n")
            else:
                if break_points == 2:
                    self.file.write(f"{chr1}  {chr2}  {chr3}  puncte = {i1} {i2}\n")
            self.file.write(f"Rezultat:    {new1}  {new2}  {new3}\n")
        return new1, new2, new3
        
        
    def crossover(self, current_population, pas, crossover_prob, encoder, break_points):
        if pas == 0:
            self.file.write(f'\n\nAplic incrucisare cu {break_points} puncte de rupere\n')
        cr = current_population.chromosomes
        cr_size = len(current_population.chromosomes[0].bitrepr) - 1
        rvs = np.random.uniform(size = len(cr)).tolist()
        marked = [(i+1) for i in range(len(rvs)) if rvs[i] < crossover_prob]
        
        def apply_2_crossover(i, break_points):
            if pas == 0:
                self.file.write(f"\nRecombinare dintre cromozomul {marked[i]} cu cromozomul {marked[i+1]}:\n")
            new1, new2 = self.two_crossover_operator(cr[marked[i]-1].bitrepr, 
                                                cr[marked[i+1]-1].bitrepr, 
                                                cr_size, pas, break_points)
            formatted_nr_1 = encoder.binary_to_decimal(new1)
            formatted_nr_2 = encoder.binary_to_decimal(new2)
            cr[marked[i]-1] = Chromosome(new1, formatted_nr_1, encoder.apply_func(self.function, float(formatted_nr_1)))
            cr[marked[i+1]-1] = Chromosome(new2, formatted_nr_2, encoder.apply_func(self.function, float(formatted_nr_2)))
         
        def apply_3_crossover(i, break_points):
            if pas == 0:
                self.file.write(f"\nRecombinare dintre cromozomul {marked[i]} cu cromozomul {marked[i+1]} si cu cromozomul {marked[i+2]}:\n")
            new1, new2, new3 = self.three_crossover_operator(cr[marked[i]-1].bitrepr, 
                                                cr[marked[i+1]-1].bitrepr,
                                                cr[marked[i+2]-1].bitrepr,
                                                cr_size, pas,  break_points)
            formatted_nr_1 = encoder.binary_to_decimal(new1)
            formatted_nr_2 = encoder.binary_to_decimal(new2)
            formatted_nr_3 = encoder.binary_to_decimal(new3)
            cr[marked[i]-1] = Chromosome(new1, formatted_nr_1, encoder.apply_func(self.function, float(formatted_nr_1)))
            cr[marked[i+1]-1] = Chromosome(new2, formatted_nr_2, encoder.apply_func(self.function, float(formatted_nr_2)))
            cr[marked[i+2]-1] = Chromosome(new3, formatted_nr_3, encoder.apply_func(self.function, float(formatted_nr_3)))
        
        if pas == 0:
            self.afis_participare_crossover(crossover_prob, rvs, current_population.chromosomes)  
        
        # efectiv incrucisarea
        while(len(marked) < 2):
            rvs = np.random.uniform(size = len(cr)).tolist()
            marked = [(i+1) for i in range(len(rvs)) if rvs[i] < crossover_prob]
        random.shuffle(marked)
        print(marked, len(marked))
        if(len(marked) > 3):
            for i in range(0, len(marked)-3, 2):
                apply_2_crossover(i, break_points)
        if len(marked) % 2 == 0:
            apply_2_crossover(len(marked)-2, break_points)
        else:
            apply_3_crossover(len(marked)-3, break_points)
               
        intermediary_pop_2 = Population(len(cr), current_population.f, cr)    
        if pas == 0:
            self.file.write("\nDupa recombinare:\n")
            intermediary_pop_2.print_current_population(self.file)
        return intermediary_pop_2
            
                  
    def mutations(self, current_population, pas, mutation_prob, encoder):
        
        if pas == 0:
            self.file.write("\nProbabilitatea de mutatie pentru fiecare gena: " + str(mutation_prob) + "\n")
            self.file.write("Au fost modificati cromozomii:\n")
        
        def apply_mutation(c, mutations):
            for m in mutations:
                gena = "1" if c[m] == "0" else "0"
                c = c[:m] + gena + c[m+1:]
            return c
        
        cr = current_population.chromosomes
        for idx, c in enumerate(cr): # c este obiect de tip cromozom
            rvs = [u <= mutation_prob for u in np.random.uniform(size = len(c.bitrepr)).tolist()]
            if any(rvs):
                if pas == 0:
                    self.file.write(f"{idx+1}\n")
                current_mutations = [i for i in range(len(rvs)) if rvs[i] == True]
                new_c = apply_mutation(c.bitrepr, current_mutations) # new_c este un sir de biti
                cr[idx] = Chromosome(new_c, encoder.binary_to_decimal(new_c), 
                          encoder.apply_func(self.function, float(encoder.binary_to_decimal(new_c))))
        children_population = Population(len(cr), current_population.f, cr)
        
        if pas == 0:
            self.file.write("\nDupa mutatie:\n")
            children_population.print_current_population(self.file)
            self.file.write("\nEvolutia maximului:\n")
        return children_population
            
            
    def run_algorithm(self, output_file_name, nr_break_points):
        
        self.file = open(output_file_name, 'w')
        enc = Encoder(self.interval, self.precision)
        self.parent_population = Population(self.pop_size, self.function)
        self.initialize_population(enc, self.parent_population) # aici generez cromozomii
        
        
        maximums=[]
        means=[]
        current_step = 0
        while current_step < self.alg_steps:
            # determin cromozomul elitist, ii fac o copie si il elimin din populatie
            # selectia si operatorii genetici ii voi aplica pe o populatie de dimensiune n-1
            max_fitness = max([c.fitness for c in self.parent_population.chromosomes])
            print(f"Max fitness-ul este {max_fitness}")
            elitist_chromosome_index  = next((i for i, c in enumerate(self.parent_population.chromosomes) 
                                             if c.fitness == max_fitness), None)
            print(f"Cromozomul elitist este {elitist_chromosome_index}")
            elitist_one = self.parent_population.chromosomes.pop(elitist_chromosome_index)
            print("Cromozomul elititst a fost eliminat din populatia curenta, el nu va participa la selectie")
            
            # etapa de selectie - aplicat pe parent_population (din care am eliminat cromozomul elitist)
            intermediary_population_1 = self.selection(self.parent_population, current_step)
            
            # etapa de incrucisare - aplicat pe intermediary_population_1
            intermediary_population_2 = self.crossover(intermediary_population_1, current_step, self.crossover_p, enc, nr_break_points)
            
            # etapa de mutatie - aplicat pe intermediary_population_2
            children_population = self.mutations(intermediary_population_2, current_step, self.mutation_p, enc) 
            children_population.chromosomes.append(elitist_one)
            
            max_fitness = max([c.fitness for c in children_population.chromosomes])
            mean_fitness = np.mean(np.array([c.fitness for c in children_population.chromosomes]))
            maximums.append(max_fitness)
            means.append(mean_fitness)
            #self.file.write(f"max = {max_fitness}   mean = {mean_fitness}  generatia = {current_step+1}\n")
            self.file.write(f"max = {max_fitness}\n")
            
            current_step += 1
            self.parent_population = children_population
        
        # fig, ax = plt.subplots()
        step = np.array([i for i in range(1, self.alg_steps+1)])
        plt.plot(step, np.array(maximums) , color = 'C3')
        plt.xlabel("Numarul de pasi")
        plt.ylabel("Fitness")
        plt.grid(which='major', color='g', linestyle='--')
        plt.title("Evolutia maximului")
        plt.show()
        
        plt.plot(step, np.array(means), '-o', color = 'C4')
        plt.xlabel("Numarul de pasi")
        plt.ylabel("Mean_fitness")
        plt.grid(which='major', color='g', linestyle='--')
        plt.title("Evolutia mediei")
        plt.show()
        self.file.close()
        
        
def parse_data(filename):
    file = open(filename, 'r')
    input_stream = file.read().split('\n')
    population_size = int(input_stream[0])
    interval = [float(x) for x in input_stream[1].split()] # capetele intervalului: D=[a,b]
    func = [float(x) for x in input_stream[2].split()] # coeficientii functiei de maximizat
    precision = int(input_stream[3])
    crossover_probab = float(input_stream[4])
    mutation_probab = float(input_stream[5])
    T = int(input_stream[6])
    # numarul de puncte de rupere folosite la incrucisare (1 sau 2)
    nr_break_points = int(input_stream[7])
    file.close()
    return population_size, interval, func, precision, crossover_probab, mutation_probab, T, nr_break_points
    
    
n, interval, f, p, pc, pm, T, nr_break_points = parse_data('input2.txt')
find_max = Algorithm(n, interval, f, p, pc, pm, T)
find_max.run_algorithm('output.txt', nr_break_points)






