using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Threading;
using IntCodeProcessor;


namespace Day11
{
    class day11program
    {
        static void Main(string[] args)
        {
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();
            List<long> commands = new List<long>();

            string text = File.ReadAllText(@"day11.txt");
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
            PaintBot bot = new PaintBot(commands.ToArray());

            bot.RunProgram();

            Console.WriteLine($"Part 1: {bot.PaintedTiles.Count}");

            Console.WriteLine("Part 2:");
            bot = new PaintBot(commands.ToArray());
            bot.RunProgram(true);
            SortedDictionary<int, List<int>> WhiteTiles = new SortedDictionary<int, List<int>>();

            int minX = int.MaxValue;
            int minY = int.MaxValue;
            int maxX = int.MinValue;
            int maxY = int.MinValue;
            int whiteCount = 0;
            int blackCount = 0;
            foreach (var t in bot.PaintedTiles.Keys)
            {
                var s = t.Split(',');
                int.TryParse(s[0], out int x);
                int.TryParse(s[1], out int y);

                if (x < minX) minX = x;
                if (x > maxX) maxX = x;
                if (y < minY) minY = y;
                if (y > maxY) maxY = y;
                if (bot.PaintedTiles[t] == 1)
                {
                    if (!WhiteTiles.ContainsKey(y))
                    {
                        WhiteTiles[y] = new List<int>();
                    }
                    WhiteTiles[y].Add(x);
                    whiteCount++;
                }
                else blackCount++;
            }
            Console.WriteLine(bot.PaintedTiles.Keys.Count);
            Console.WriteLine(whiteCount);
            Console.WriteLine(blackCount);


            int SecondWhiteCount = 0;
            foreach (var line in WhiteTiles.Keys)
            {
                SecondWhiteCount += WhiteTiles[line].Count;
                string wline = string.Empty;
                for (int j = minX; j <= maxX; j++)
                {
                    if (WhiteTiles[line].Contains(j)) wline += "*";
                    else wline += " ";
                }
                if (wline != string.Empty) Console.WriteLine(wline);
            }

            stopWatch.Stop();
            Console.WriteLine(SecondWhiteCount);
            Console.WriteLine($"Elapsed: {stopWatch.Elapsed}");
            Console.ReadLine();
        }
    }

    public class PaintBot
    {
        public Processor cpu;
        public Direction CurrentlyFacing = Direction.Up;
        public Dictionary<string, int> PaintedTiles = new Dictionary<string, int>();
        public HashSet<string> VisitedTiles = new HashSet<string>();
        public int x;
        public int y;
        private bool isProcessing = false;
        public Queue<int> outPutStream = new Queue<int>();

        public PaintBot(long[] Program)
        {
            cpu = new Processor(Program);
            VisitedTiles.Add("0,0");
            cpu.ProgramFinish += Cpu_ProgramFinish;
            cpu.ProgramOutput += Cpu_ProgramOutput;

        }

        private void Cpu_ProgramOutput(object sender, OutputEventArgs e)
        {
            Monitor.Enter(outPutStream);
            try
            {
                outPutStream.Enqueue((int)e.OutputValue);
            }
            finally
            {
                Monitor.Exit(outPutStream);
            }
        }

        private void Cpu_ProgramFinish(object sender, EventArgs e)
        {
            isProcessing = false;
        }

        public void RunProgram(bool part2 = false)
        {
            isProcessing = true;
            outPutStream.Clear();
            Thread a = new Thread(new ThreadStart(cpu.ProccessProgram));
            a.Start();
            while (isProcessing)
            {
                if (part2)
                {
                    cpu.AddInput(1);
                    part2 = false; //forces back to normal operation
                    PaintedTiles["0,0"] = 1;
                }
                else if (PaintedTiles.ContainsKey($"{x},{y}"))
                {
                    cpu.AddInput(PaintedTiles[$"{x},{y}"]);
                }
                else
                {
                    cpu.AddInput(0);
                }


                int QL = 0;
                do
                {
                    lock (outPutStream)
                    {
                        QL = outPutStream.Count;
                    }
                }
                while (QL < 2 && isProcessing);
                if (!isProcessing) break;
                int paintColor, turnDir;
                lock (outPutStream)
                {
                    paintColor = outPutStream.Dequeue();
                    turnDir = outPutStream.Dequeue();
                }

                PaintedTiles[$"{x},{y}"] = paintColor;

                if (turnDir == 0)
                {
                    CurrentlyFacing--;
                }
                else
                {
                    CurrentlyFacing++;
                }
                if (CurrentlyFacing < Direction.Up) CurrentlyFacing = Direction.Left;
                if (CurrentlyFacing > Direction.Left) CurrentlyFacing = Direction.Up;

                switch (CurrentlyFacing)
                {
                    case Direction.Up: y++; break;
                    case Direction.Right: x++; break;
                    case Direction.Down: y--; break;
                    case Direction.Left: x--; break;
                }
                VisitedTiles.Add($"{x},{y}");
            }
        }
    }

    public enum Direction
    {
        Up = 0,
        Left = 3,
        Down = 2,
        Right = 1
    }
}
