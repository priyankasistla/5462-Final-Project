-------------------------------------------------------------------------------
-- Project: Pipelined Floating Point A/S/M
--
-- AUTHOR NAME: Vince McKinsey
--
-- NOTE ON VHDL IN THIS FILE: 
-- NOTE TO READER: 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

ENTITY cmaAdderCell_Level2 IS
  PORT  ( A,B                 : IN  std_logic;
          cin,cinP0,cinP1     : IN  std_logic;
          muxCtrlin           : IN  std_logic;
          sum                 : OUT std_logic;
          cout,coutP0,coutP1  : OUT std_logic;
          muxCtrlout          : OUT std_logic
        );
END cmaAdderCell_Level2;

ARCHITECTURE dataflow OF cmaAdderCell_Level2 IS
  COMPONENT xor_unit IS
    PORT  ( A,B             : IN  std_logic;
            xorout,xnorout  : OUT std_logic
          );
  END COMPONENT;

  COMPONENT carry_unit IS
    PORT  ( cin,B : IN  std_logic;
            AxorB : IN  std_logic;
            cout  : OUT std_logic
          );
  END COMPONENT;
  
  COMPONENT sum_unit IS
    PORT  ( AxorB,AxnorB  : IN  std_logic;
            cin           : IN  std_logic;
            sum           : OUT std_logic
          );
  END COMPONENT;

  COMPONENT mux21 IS
    PORT  ( input     : IN  std_logic_vector(1 downto 0);
            selector  : IN  std_logic;
            output    : OUT std_logic
          );
  END COMPONENT;
  
  FOR ALL : xor_unit    USE ENTITY  WORK.cmaXor_unit(dataflow);
  FOR ALL : carry_unit  USE ENTITY  WORK.cmaCarry_unit(dataflow);
  FOR ALL : sum_unit    USE ENTITY  WORK.cmaSum_unit(dataflow);
  FOR ALL : mux21       USE ENTITY  WORK.mux21(dataflow);
  
  SIGNAL AxorB,AxnorB          : std_logic;
  SIGNAL coutP0temp,coutP1temp : std_logic;
  
BEGIN
  xorAB : xor_unit PORT MAP
    ( A, B,
      AxorB, AxnorB
    );
    
  carryunitP0 : carry_unit PORT MAP
    ( cinP0, B,
      AxorB,
      coutP0temp
    );
    
  muxcout : mux21 PORT MAP
    ( coutP1temp & coutP0temp,
      muxCtrlin,
      cout
    );
    
  carryunitP1 : carry_unit PORT MAP
    ( cinP1, B, 
      AxorB,
      coutP1temp
    );
    
  sumunit : sum_unit PORT MAP
    ( AxorB, AxnorB,
      cin,
      sum
    );
  
  coutP0      <=  coutP0temp;
  coutP1      <=  coutP1temp;
  muxCtrlout  <=  muxCtrlin;
  
END dataflow;