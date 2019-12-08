using System;
using System.Collections.Generic;
using IntCodeProcessor;
using System.IO;
using System.Threading;
using System.Linq;
using System.Diagnostics;

namespace Day7
{
    class Program
    {
        private static List<long> returnedPowers = new List<long>();
        private static List<long> outPutFromE = new List<long>();
        static void Main(string[] args)
        {
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();
            List<long> commands = new List<long>();

            string text = File.ReadAllText(@"day07.txt");
            foreach(string s in text.Split(','))
            {
                long parsed = 0;
                if(long.TryParse(s, out parsed))
                {
                    commands.Add(parsed);
                }
                else
                {
                    throw new Exception($"Failed to parse '{s}' to a long");
                }
            }

            List<long[]> firstPerms = GetPermutations(new List<long> { 0, 1, 2, 3, 4 });
            List<long[]> secondPerms = GetPermutations(new List<long> { 5, 6, 7, 8, 9 });

            Processor pcA = new Processor(commands.ToArray());
            Processor pcB = new Processor(commands.ToArray());
            Processor pcC = new Processor(commands.ToArray());
            Processor pcD = new Processor(commands.ToArray());
            Processor pcE = new Processor(commands.ToArray());
            pcE.ProgramOutput += Pc_ProgramOutput;
            pcE.ProgramFinish += PcE_ProgramFinish;


            pcB.ListenToProcessor(pcA);
            pcC.ListenToProcessor(pcB);
            pcD.ListenToProcessor(pcC);
            pcE.ListenToProcessor(pcD);

            foreach (long[] perm in firstPerms)
            {
                pcA.AddInput(perm[0]);
                pcA.AddInput(0);
                pcB.AddInput(perm[1]);
                pcC.AddInput(perm[2]);
                pcD.AddInput(perm[3]);
                pcE.AddInput(perm[4]);

                pcA.ProccessProgram();
                pcB.ProccessProgram();
                pcC.ProccessProgram();
                pcD.ProccessProgram();
                pcE.ProccessProgram();
            }

            long max = returnedPowers.Max();
            Console.WriteLine($"Part 1: {max}");

            returnedPowers.Clear();
           

            pcA.ListenToProcessor(pcE); //Allow E to loop back to A

            

            foreach (long[] perm in secondPerms)
            {
                pcA.ResetInputs();
                pcB.ResetInputs();
                pcC.ResetInputs();
                pcD.ResetInputs();
                pcE.ResetInputs();

                pcA.AddInput(perm[0]);
                pcA.AddInput(0);
                pcB.AddInput(perm[1]);
                pcC.AddInput(perm[2]);
                pcD.AddInput(perm[3]);
                pcE.AddInput(perm[4]);

                Thread a = new Thread(new ThreadStart(pcA.ProccessProgram));
                Thread b = new Thread(new ThreadStart(pcB.ProccessProgram));
                Thread c = new Thread(new ThreadStart(pcC.ProccessProgram));
                Thread d = new Thread(new ThreadStart(pcD.ProccessProgram));
                //Gonna start threading for part 2 because wow I hate myself.

                a.Start();
                b.Start();
                c.Start();
                d.Start();
                pcE.ProccessProgram(); //run this on the main thread because sometimes it runs too fast to .join()
            }

            max = returnedPowers.Max();
            Console.WriteLine($"Part 2: {max}");

            returnedPowers.Clear();


            stopWatch.Stop();
            Console.WriteLine($"Time Taken: {stopWatch.Elapsed}");

            Console.ReadLine();
        }

        private static void PcE_ProgramFinish(object sender, EventArgs e)
        {
            returnedPowers.Add(outPutFromE[outPutFromE.Count - 1]);
            outPutFromE.Clear();

        }

        private static void Pc_ProgramOutput(object sender, OutputEventArgs e)
        {
            outPutFromE.Add(e.OutputValue);
        }


        private static List<long[]> GetPermutations(List<long> things, List<long> current = null)
        {
            List<long[]> res = new List<long[]>();
            if(current == null)
            {
                current = new List<long>();
            }
            if (things.Count > 0)
            {
                foreach (long t in things)
                {
                    List<long> newP = new List<long>(current);
                    newP.Add(t);

                    List<long> newThings = new List<long>(things);
                    newThings.Remove(t);
                    res.AddRange(GetPermutations(newThings, newP));
                }
            }
            else
            {
                res.Add(current.ToArray());
            }

            return res;
        }
    }
}
