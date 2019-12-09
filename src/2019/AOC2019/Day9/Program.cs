using IntCodeProcessor;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;

namespace Day9
{
    class Program
    {
        static void Main(string[] args)
        {
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();
            List<long> commands = new List<long>();

            string text = File.ReadAllText(@"day09.txt");
            foreach (string s in text.Split(','))
            {
                long parsed = 0;
                if (long.TryParse(s, out parsed))
                {
                    commands.Add(parsed);
                }
                else
                {
                    throw new Exception($"Failed to parse '{s}' to a long");
                }
            }

            Processor pcA = new Processor(commands.ToArray());
            pcA.ProgramOutput += Pc_ProgramOutput;
            pcA.ProgramFinish += Pc_ProgramFinish;
            pcA.AddInput(1);

            Console.WriteLine("Part 1:");
            pcA.ProccessProgram();

            pcA.ResetInputs();
            pcA.AddInput(2);

            Console.WriteLine("Part 2:");
            pcA.ProccessProgram();

            stopWatch.Stop();
            Console.WriteLine($"Time Taken: {stopWatch.Elapsed}");

            Console.ReadLine();
        }

        private static void Pc_ProgramFinish(object sender, EventArgs e)
        {
            
        }

        private static void Pc_ProgramOutput(object sender, OutputEventArgs e)
        {
            Console.WriteLine(e.OutputValue);
        }
    }
}
