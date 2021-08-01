
  with popvsvac as
  (


  drop table #PercentPopulationVaccinated
  create table #PercentPopulationVaccinated
(
 continent nvarchar(255),
 Location  nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RolllingPeopleVaccinated numeric
 )

 insert into #PercentPopulationVaccinated
  select dea.continent,dea.location as Location,dea.date as Date,dea.population,vac.new_vaccinations as New_vaccinations ,
 -- sum(convert(int,vac.new_vaccinations)) over (partition by dea.location) as new_vac,
  sum(convert(int,vac.new_vaccinations)) over (partition by dea.location 
  order by dea.location,dea.date) as RolllingPeopleVaccinated
  from  [dbo].[CovidDeaths] dea 
join [dbo].[CovidVaccinations] vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null 
and dea.location = 'Finland'
order by 2,3

select *,(RolllingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

drop view PercentPopulationVaccinated
create view PercentPopulationVaccinated as
select dea.continent,dea.location as Location,dea.date as Date,dea.population,vac.new_vaccinations as New_vaccinations ,
 -- sum(convert(int,vac.new_vaccinations)) over (partition by dea.location) as new_vac,
  sum(convert(int,vac.new_vaccinations)) over (partition by dea.location 
  order by dea.location,dea.date) as RolllingPeopleVaccinated
  from  [dbo].[CovidDeaths] dea 
join [dbo].[CovidVaccinations] vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null 
