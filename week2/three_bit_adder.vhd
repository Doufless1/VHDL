ARCHITECTURE structural OF three_bit_adder IS
    COMPONENT full_adder
        PORT (
            A, B, Cin : IN std_logic;
            Sum, Cout : OUT std_logic
        );
    END COMPONENT;
    
    FOR ALL : full_adder USE ENTITY WORK.full_adder;
    
    SIGNAL C1, C2 : std_logic;
BEGIN
    FA0: full_adder PORT MAP (A(0), B(0), Cin, Sum(0), C1);
    FA1: full_adder PORT MAP (A(1), B(1), C1, Sum(1), C2);
    FA2: full_adder PORT MAP (A(2), B(2), C2, Sum(2), Cout);
END structural;
